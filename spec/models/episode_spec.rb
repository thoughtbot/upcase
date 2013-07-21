require 'spec_helper'

describe Episode do
  context 'associations' do
    it { should have_many(:classifications) }
    it { should have_many(:topics).through(:classifications) }
    it { should have_many(:products).through(:topics) }
    it { should have_many(:workshops).through(:topics) }
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :published_on }
  end

  it_behaves_like 'it has related items'

  it 'assigns the next number when created' do
    episode = build(:episode, number: nil)

    episode.save!

    expect(episode.number).to eq 1
  end

  it 'does not assign new number when created' do
    episode = build(:episode, number: 99)

    episode.save!

    expect(episode.number).to eq 99
  end

  describe '#to_param' do
    it 'returns the episode number' do
      episode = create(:episode, number: 99)

      expect(episode.to_param).to eq 99
    end
  end

  describe "self.published" do
    it "does not include episodes published in the future" do
      published = create(:episode, published_on: 1.day.ago)
      future = create(:episode, published_on: 1.day.from_now)
      Episode.published.should include published
      Episode.published.should_not include future
    end

    it "orders by most recently published" do
      create(:episode, published_on: 7.days.ago)
      first = create(:episode, published_on: 2.days.ago)
      Episode.published.first.should == first
    end
  end

  describe ".full_title" do
    it 'includes the episode number and title' do
      episode = create(:episode, title: 'Hello')
      episode.full_title.should == "Episode #{episode.number}: #{episode.title}"
    end
  end

  describe ".rss_pub_date" do
    it 'conforms to the rss specification for publication date' do
      Timecop.freeze(Time.zone.now) do
        episode = create(:episode, published_on: 1.days.ago)
        episode.rss_pub_date.should == 1.days.ago.strftime('%a, %d %b %Y %H:%M:%S %z')
      end
    end
  end

  describe ".products" do
    it 'should not duplicate products' do
      episode = create(:episode)
      product = create(:product)
      topic_one = create(:topic)
      topic_one.products << product
      topic_two = create(:topic)
      topic_two.products << product
      episode.topics << topic_one
      episode.topics << topic_two
      episode.products.should == [product]
    end
  end

  describe '.increment_downloads' do
    it 'increments the download count by 1' do
      episode = create(:episode, downloads_count: 4)
      episode.increment_downloads
      episode.downloads_count.should eq 5
    end
  end
end
