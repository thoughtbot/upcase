require "rails_helper"

describe Product do
  it { should have_many(:classifications).dependent(:destroy) }
  it { should have_many(:downloads).dependent(:destroy) }
  it { should have_many(:licenses).dependent(:destroy) }
  it { should have_many(:topics).through(:classifications) }
  it { should have_many(:videos).dependent(:destroy) }
  it { should validate_presence_of(:slug) }

  context "uniqueness" do
    before do
      create :product
    end

    it { should validate_uniqueness_of(:slug) }
  end

  describe "self.promoted" do
    it "returns promoted products" do
      promoted_products = create_list(:product, 2, promoted: true)
      create(:product, promoted: false)

      expect(Product.promoted).to eq(promoted_products)
    end
  end

  describe "delete_product_image" do
    it "RailsAdmin doesn't clear product image if value is not '1'" do
      product = Product.new
      product.product_image.stubs(:clear)
      product.delete_product_image = nil

      product.valid?

      expect(product.product_image).to have_received(:clear).never
    end

    it "RailsAdmin clears product image if value is 1" do
      product = Product.new
      product.product_image.stubs(:clear)
      product.delete_product_image = "1"

      product.valid?

      expect(product.product_image).to have_received(:clear)
    end
  end

  describe "license_for" do
    it 'returns the license when a user has licensed a product' do
      user = create(:user)
      license = create(:license, user: user)
      product = license.licenseable

      expect(product.license_for(user)).to eq license
    end

    it 'returns nil when a user has not licensed a product' do
      user = create(:user)
      license = create(:license)
      product = license.licenseable

      expect(product.license_for(user)).to be_nil
    end
  end

  describe '#collection?' do
    it 'returns false' do
      expect(Product.new).not_to be_collection
    end
  end

  describe "#fulfill" do
    it "fulfills using GitHub with a GitHub team" do
      user = build_stubbed(:user)
      fulfillment = stub("fulfillment", :fulfill)
      product = build_stubbed(:product, github_team: "example")
      GithubFulfillment.stubs(:new).with(product, user).returns(fulfillment)

      product.fulfill(user)

      expect(fulfillment).to have_received(:fulfill)
    end
  end
end
