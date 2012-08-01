require 'spec_helper'

describe Product do
  it { should validate_presence_of :name }
  it { should validate_presence_of :sku }
  it { should validate_presence_of :individual_price }
  it { should validate_presence_of :company_price }
  it { should validate_presence_of :fulfillment_method }

  it { should have_many(:classifications) }
  it { should have_many(:topics).through(:classifications) }

  describe "#books" do
    it "includes only books" do
      book = FactoryGirl.create(:product, product_type: 'book')
      book2 = FactoryGirl.create(:product, product_type: 'book and example')
      screencast = FactoryGirl.create(:product, product_type: 'screencast')

      Product.books.should include book
      Product.books.should include book2
      Product.books.should_not include screencast
    end
  end

  describe '#find_all_books_or_by_topics' do
    it 'includes books for the given topics' do
      topic_1 = FactoryGirl.create(:topic, name: 'ruby')
      topic_2 = FactoryGirl.create(:topic, name: 'rubygems')
      product = FactoryGirl.create(:product, product_type: 'book', active: true)
      product_not_in_topics = FactoryGirl.create(:product, product_type: 'book', active: true)

      found_topics = [topic_1, topic_2]
      found_topics.each { |topic| topic.products << product }

      Product.find_all_books_or_by_topics(found_topics).should include(product)
      Product.find_all_books_or_by_topics(found_topics).should_not include(product_not_in_topics)
    end

    it 'includes all books if no topics are found' do
      product_1 = FactoryGirl.create(:product, product_type: 'book', active: true)
      product_2 = FactoryGirl.create(:product, product_type: 'book', active: true)
      found_topics = [FactoryGirl.create(:topic)]
      Product.find_all_books_or_by_topics(found_topics).should include product_1
      Product.find_all_books_or_by_topics(found_topics).should include product_2
    end
  end

  describe "#screencasts" do
    it "includes only screencasts" do
      screencast = FactoryGirl.create(:product, product_type: 'screencast')
      screencast2 = FactoryGirl.create(:product, product_type: 'screencast and example')
      book = FactoryGirl.create(:product, product_type: 'book')

      Product.screencasts.should include screencast
      Product.screencasts.should include screencast2
      Product.screencasts.should_not include book
    end
  end

  describe '#find_all_screencasts_or_by_topics' do
    it 'includes screencasts for the given topics' do
      topic_1 = FactoryGirl.create(:topic, name: 'ruby')
      topic_2 = FactoryGirl.create(:topic, name: 'rubygems')
      product = FactoryGirl.create(:product, product_type: 'screencast', active: true)
      product_not_in_topics = FactoryGirl.create(:product, product_type: 'screencast', active: true)

      found_topics = [topic_1, topic_2]
      found_topics.each { |topic| topic.products << product }

      Product.find_all_screencasts_or_by_topics(found_topics).should include(product)
      Product.find_all_screencasts_or_by_topics(found_topics).should_not include(product_not_in_topics)
    end

    it 'includes all products if no topics are found' do
      product_1 = FactoryGirl.create(:product, product_type: 'screencast', active: true)
      product_2 = FactoryGirl.create(:product, product_type: 'screencast', active: true)
      found_topics = [FactoryGirl.create(:topic)]
      Product.find_all_screencasts_or_by_topics(found_topics).should include product_1
      Product.find_all_screencasts_or_by_topics(found_topics).should include product_2
    end
  end

  describe "#for_topic" do
    it "includes only products for the given topic" do
      topic = FactoryGirl.create(:topic)
      in_topic = FactoryGirl.create(:product)
      topic.products << in_topic
      not_in_topic = FactoryGirl.create(:product)

      Product.for_topic(topic).should include in_topic
      Product.for_topic(topic).should_not include not_in_topic
    end
  end
end
