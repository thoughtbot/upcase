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
  it { should validate_presence_of(:company_price) }
  it { should validate_presence_of(:fulfillment_method) }
  it { should validate_presence_of(:individual_price) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:sku) }

  context '#announcement' do
    it 'calls Announcement.current' do
      Announcement.stubs :current
      product = create(:book_product)
      product.announcement
      Announcement.should have_received(:current)
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
end
