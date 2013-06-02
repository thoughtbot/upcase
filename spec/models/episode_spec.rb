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
    it { should validate_presence_of :file_size }
    it { should validate_presence_of :duration }
    it { should validate_presence_of :file }
    it { should validate_presence_of :description }
    it { should validate_presence_of :published_on }
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
    it 'includes the eposide number and title' do
      episode = create(:episode, title: 'Hello')
      episode.full_title.should == "Episode #{episode.id}: #{episode.title}"
    end
  end

  describe ".rss_pub_date" do
    it 'conforms to the rss specification for publication date' do
      Timecop.freeze(Time.now) do
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

  describe 'loading info from the mp3' do
    it 'loads information from the mp3 when not provided' do
      episode = Episode.new
      episode.file = 'http://example.com/file.mp3'

      episode.stubs(open: stub(size: 1234))
      tag_stub = stub(
        TIT2: 'Episode 1: The Show',
        TDES: "Description\nNotes\nNotes2",
        TDRL: '2013-06-03'
      )
      mp3_stub = stub(length: 10.12, tag2: tag_stub)
      Mp3Info.stubs(:open).yields(mp3_stub)

      episode.save!

      episode.title.should eq 'The Show'
      episode.description.should eq 'Description'
      episode.notes.should eq "Notes\nNotes2"
      episode.duration.should eq 10
      episode.file_size.should eq 1234
      episode.published_on.should eq Date.parse('2013-06-03')
    end
  end
end
