require 'spec_helper'

describe Topic do
  # Associations
  it { should have_many(:articles).through(:classifications) }
  it { should have_many(:classifications) }
  it { should have_many(:courses).through(:classifications) }
  it { should have_many(:products).through(:classifications) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

  context '#blog_url' do
    it 'points to the tumblr tag archive' do
      topic = create(:topic)
      tag_archive = "http://robots.thoughtbot.com/tagged/#{topic.name}"
      topic.blog_url.should == tag_archive
    end
  end

  context '#books' do
    it 'only includes books' do
      topic = create(:topic)
      book = create(:product, product_type: 'book')
      topic.products << book
      topic.products << create(:product, product_type: 'video')
      topic.books.should == [book]
    end
  end

  context '.create' do
    before do
      @topic = create(:topic, name: ' Test Driven Development ')
    end

    it 'generates a stripped, url encoded slug based on name' do
      @topic.slug.should == 'test+driven+development'
    end
  end

  context '#screencasts_and_videos' do
    it 'only includes screencasts and videos' do
      topic = create(:topic)
      screencast = create(:product, product_type: 'screencast')
      topic.products << screencast
      video = create(:product, product_type: 'video')
      topic.products << video
      topic.products << create(:product, product_type: 'book')
      topic.screencasts_and_videos.should =~ [screencast, video]
    end
  end

  context '.top' do
    before do
      25.times do |i|
        create :topic, count: i, featured: true
      end
    end

    it 'returns the top 20 featured topics' do
      Topic.top.count.should == 20
      Topic.top.all? {|topic| topic.count >= 5 }.should be
    end
  end

  context 'validations' do
    context 'uniqueness' do
      before do
        create :topic
      end

      it { should validate_uniqueness_of(:slug) }
    end
  end
end
