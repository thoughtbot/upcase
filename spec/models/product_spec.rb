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

  describe '#original_alternate_individual_price' do
    it 'returns the original alternate individual price' do
      product = Product.new(alternate_individual_price: 1)

      product.original_alternate_individual_price.should == 1
    end

    it 'returns the non-alternate price if there is no alternate' do
      product = Product.new(individual_price: 3, alternate_individual_price: nil)

      product.original_alternate_individual_price.should == 3
    end
  end

  describe '#original_alternate_company_price' do
    it 'returns the original alternate company price' do
      product = Product.new(alternate_company_price: 1)

      product.original_alternate_company_price.should == 1
    end

    it 'returns the non-alternate price if there is no alternate' do
      product = Product.new(company_price: 3, alternate_company_price: nil)

      product.original_alternate_company_price.should == 3
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

    it 'returns a discounted alternate individual price' do
      product = create(:product, alternate_individual_price: 5)
      product.alternate_individual_price.should == 5
      product.discount_percentage = 2
      product.alternate_individual_price.should == 4
    end

    it 'returns a discounted alternate company price' do
      product = create(:product, alternate_company_price: 5)
      product.alternate_company_price.should == 5
      product.discount_percentage = 2
      product.alternate_company_price.should == 4
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

  describe '#video_available?' do
    it 'returns true regardless of active_on_day' do
      product = create(:product)
      video = create(:video, watchable: product, active_on_day: 20)
      expect(product.video_available?(video)).to be
    end
  end

  describe '#video_available_on' do
    it 'returns today regardless of active_on_day' do
      product = create(:product)
      video_one = create(:video, watchable: product, active_on_day: 0, title: 'Video One')
      video_two = create(:video, watchable: product, active_on_day: 2, title: 'Video One')
      expect(product.video_available_on(video_one)).to eq Date.today
      expect(product.video_available_on(video_two)).to eq Date.today
    end
  end
end
