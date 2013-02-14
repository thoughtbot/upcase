require 'spec_helper'

describe Article do
  context 'associations' do
    it { should have_many(:classifications) }
    it { should have_many(:topics).through(:classifications) }
    it { should have_many(:products).through(:topics) }
    it { should have_many(:workshops).through(:topics) }
  end

  context 'validations' do
    it { should validate_presence_of(:body_html) }
    it { should validate_presence_of(:published_on) }
    it { should validate_presence_of(:title) }
  end

  context ".ordered" do
    before do
      create(:article, published_on: 30.days.ago)
      create(:article, published_on: 50.days.ago)
    end

    it "sorts by published_on desc" do
      Article.ordered.should == Article.all.sort_by { |a| a.published_on }.reverse
    end
  end

  context '.top' do
    before do
      25.times do |i|
        create :article, published_on: i.days.ago
      end
    end

    it 'returns the top 10 featured articles' do
      Article.top.count.should == 10
      Article.top.all? {|article| article.published_on >= 10.days.ago.to_date }.should be
    end
  end

  context '.local' do
    it 'only includes local articles' do
      article = create(:article)
      tumblr_article = create(:tumblr_article)

      expect(Article.local).to include article
      expect(Article.local).not_to include tumblr_article
    end
  end

  context '.published' do
    it 'only includes articles published_on greater or equal to today' do
      today = create(:article, published_on: Date.today)
      tomorrow = create(:article, published_on: Date.tomorrow)
      yesterday = create(:article, published_on: Date.yesterday)

      expect(Article.published).to include today
      expect(Article.published).to include yesterday
      expect(Article.published).not_to include tomorrow
    end

    it 'does not include draft articles' do
      draft = create(:article, draft: true)
      published = create(:article, draft: false)

      expect(Article.published).to include published
      expect(Article.published).not_to include draft
    end
  end

  context 'published?' do
    it 'returns false for draft articles' do
      draft = create(:article, draft: true)
      published = create(:article, draft: false)

      expect(draft).not_to be_published
      expect(published).to be_published
    end

    it 'returns false for articles in the future' do
      future = create(:article, published_on: 7.days.from_now)
      published = create(:article, published_on: Date.today)

      expect(future).not_to be_published
      expect(published).to be_published
    end
  end

  context 'to_param' do
    it 'is the id and the parameterized title' do
      article = create(:article, title: 'Test Title')
      expect(article.to_param).to eq "#{article.id}-test-title"
    end
  end

  context 'body=' do
    it 'saves an html version of the markdown to body_html when saved' do
      article = build(:article)
      article.body = '_body_'
      article.save
      expect(article.body_html).to include '<em>body</em>'
      article.body = '__body__'
      article.save
      expect(article.body_html).to include '<strong>body</strong>'
    end

    it 'saves an html version of the markdown body when created with mass assignment' do
      article = Article.new
      article.assign_attributes(title: 'Test', body: '*hello*', published_on: Date.today)
      article.save!
      expect(article.body_html).not_to be_nil
    end

    it "doesn't overwrite body_html if there is no markdown" do
      article = create(:article, body_html: 'hello')
      article.body = ''
      article.save
      expect(article.body_html).to eq 'hello'
    end

    it 'also saves the original Markdown in body' do
      article = Article.new
      article.assign_attributes(title: 'Test', body: '*hello*', published_on: Date.today)
      article.save!
      expect(article.reload.body).to eq '*hello*'
    end
  end

  context 'keywords' do
    it 'gives a comma separated list of topics' do
      article = create(:article)
      topic = create(:topic)
      topic.articles << article
      topic_two = create(:topic)
      topic_two.articles << article

      expect(article.keywords).to eq "#{topic.name},#{topic_two.name}"
    end
  end

  context 'local?' do
    it 'returns true for articles that do not have an external_url' do
      article = build(:article, external_url: nil)

      expect(article.local?).to be
    end

    it 'returns false for articles that do have an external_url' do
      article = build(:article, external_url: 'http://thoughtbot.com')

      expect(article.local?).not_to be
    end
  end
end
