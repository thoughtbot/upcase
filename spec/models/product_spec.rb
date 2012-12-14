require 'spec_helper'

describe Product do
  # Associations
  it { should have_many(:announcements).dependent(:destroy) }
  it { should have_many(:classifications) }
  it { should have_many(:downloads) }
  it { should have_many(:purchases) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:videos) }

  # Validations
  it { should validate_presence_of(:fulfillment_method) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:sku) }

  describe '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      product = create(:book_product)
      product.announcement
      Announcement.should have_received(:current)
    end
  end

  describe "#meta_keywords" do
    it 'returns a comma delimited string of topics' do
      book = create(:book_product)
      book.topics << create(:topic, name: 'Ruby')
      book.topics << create(:topic, name: 'Rails')
      book.meta_keywords.should == 'Ruby, Rails'
    end
  end

  describe '.books' do
    it 'only includes books' do
      book = create(:book_product)
      create :video_product
      Product.books.should == [book]
    end
  end

  describe '.promoted' do
    it 'returns the promoted product in the location' do
      product = create(:product, promo_location: 'left')
      Product.promoted('left').should == product
    end
  end

  describe '.videos' do
    it 'only includes videos' do
      video = create(:video_product)
      create :book_product
      Product.videos.should == [video]
    end
  end

  describe '.workshops' do
    it 'only includes workshops' do
      workshop = create(:workshop_product)
      create :book_product
      Product.workshops.should == [workshop]
    end
  end

  describe 'with a discount' do
    it 'returns a discounted individual price' do
      product = create(:product, individual_price: 50)
      product.individual_price.should == 50
      product.discount_percentage = 20
      product.individual_price.should == 40
    end

    it 'returns a discounted company price' do
      product = create(:product, company_price: 50)
      product.company_price.should == 50
      product.discount_percentage = 20
      product.company_price.should == 40
    end

    it 'reports that the product is discounted' do
      product = create(:product, discount_percentage: 20)
      product.should be_discounted
    end
  end

  it 'reports that it is not discounted' do
    product = create(:product, discount_percentage: 0)
    product.should_not be_discounted
  end
end
