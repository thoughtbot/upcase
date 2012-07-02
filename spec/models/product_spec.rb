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
