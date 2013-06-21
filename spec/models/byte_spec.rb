require 'spec_helper'

describe Byte do
  context 'associations' do
    it { should have_many(:classifications) }
    it { should have_many(:products).through(:topics) }
    it { should have_many(:topics).through(:classifications) }
    it { should have_many(:workshops).through(:topics) }
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:body_html) }
    it { should validate_presence_of(:published_on) }
    it { should validate_presence_of(:title) }
  end

  it_behaves_like 'it has related items'

  context ".ordered" do
    it "sorts by published_on desc" do
      newer = create(:byte, published_on: 30.days.ago)
      older = create(:byte, published_on: 50.days.ago)
      expect(Byte.ordered).to eq [newer, older]
    end
  end

  context '.published' do
    it 'only includes bytes published_on greater or equal to today' do
      create(:byte, published_on: Time.zone.today, title: 'today')
      create(:byte, published_on: 1.day.from_now, title: 'tomorrow')
      create(:byte, published_on: 1.day.ago, title: 'yesterday')

      expect(Byte.published.map(&:title)).to eq %w(today yesterday)
    end

    it 'does not include draft bytes' do
      create(:byte, draft: true, title: 'draft')
      create(:byte, draft: false, title: 'published')

      expect(Byte.published.map(&:title)).to eq %w(published)
    end
  end

  context '.published_today' do
    it 'only includes bytes published_on today' do
      create(:byte, published_on: Time.zone.today, title: 'today')
      create(:byte, published_on: 1.day.from_now, title: 'tomorrow')
      create(:byte, published_on: 1.week.ago, title: 'last week')

      expect(Byte.published_today.map(&:title)).to eq(%w(today))
    end

    it 'does not include draft bytes' do
      create(:byte, draft: true, published_on: Time.zone.today, title: 'draft')
      create(:byte, draft: false, published_on: Time.zone.today, title: 'published')

      expect(Byte.published_today.map(&:title)).to eq(%w(published))
    end
  end

  context 'published?' do
    it 'returns false for draft bytes' do
      draft = create(:byte, draft: true)
      published = create(:byte, draft: false)

      expect(draft).not_to be_published
      expect(published).to be_published
    end

    it 'returns false for bytes in the future' do
      future = create(:byte, published_on: 7.days.from_now)
      published = create(:byte, published_on: Time.zone.today)

      expect(future).not_to be_published
      expect(published).to be_published
    end
  end

  context 'to_param' do
    it 'is the id and the parameterized title' do
      byte = create(:byte, title: 'Test Title')
      expect(byte.to_param).to eq "#{byte.id}-test-title"
    end
  end

  context 'body=' do
    it 'saves an html version of the markdown to body_html when saved' do
      byte = build(:byte)
      byte.body = '_body_'
      byte.save
      expect(byte.body_html).to include '<em>body</em>'
      byte.body = '__body__'
      byte.save
      expect(byte.body_html).to include '<strong>body</strong>'
    end

    it 'saves an html version of the markdown body when created with mass assignment' do
      byte = Byte.new
      byte.assign_attributes(title: 'Test', body: '*hello*', published_on: Time.zone.today)
      byte.save!
      expect(byte.body_html).not_to be_nil
    end

    it "doesn't overwrite body_html if there is no markdown" do
      byte = create(:byte, body_html: 'hello')
      byte.body = ''
      byte.save
      expect(byte.body_html).to eq 'hello'
    end

    it 'also saves the original Markdown in body' do
      byte = Byte.new
      byte.assign_attributes(title: 'Test', body: '*hello*', published_on: Time.zone.today)
      byte.save!
      expect(byte.reload.body).to eq '*hello*'
    end
  end

  context 'keywords' do
    it 'gives a comma separated list of topics' do
      byte = create(:byte)
      topic = create(:topic)
      topic.bytes << byte
      topic_two = create(:topic)
      topic_two.bytes << byte

      expect(byte.keywords).to eq "#{topic.name},#{topic_two.name}"
    end
  end
end
