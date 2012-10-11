require 'spec_helper'

describe Product do
  # Associations
  it { should have_many(:classifications) }
  it { should have_many(:topics).through(:classifications) }

  # Validations
  it { should validate_presence_of(:company_price) }
  it { should validate_presence_of(:fulfillment_method) }
  it { should validate_presence_of(:individual_price) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:sku) }

  context '.books' do
    it 'only includes books' do
      book = create(:book_product)
      create :video_product
      Product.books.should == [book]
    end
  end

  context '.videos' do
    it 'only includes videos' do
      video = create(:video_product)
      create :book_product
      Product.videos.should == [video]
    end
  end
end
