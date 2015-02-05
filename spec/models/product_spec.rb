require "rails_helper"

describe Product do
  it { should have_many(:classifications).dependent(:destroy) }
  it { should have_many(:downloads).dependent(:destroy) }
  it { should have_many(:repositories).dependent(:destroy) }
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
      allow(product.product_image).to receive(:clear)
      product.delete_product_image = nil

      product.valid?

      expect(product.product_image).not_to have_received(:clear)
    end

    it "RailsAdmin clears product image if value is 1" do
      product = Product.new
      allow(product.product_image).to receive(:clear)
      product.delete_product_image = "1"

      product.valid?

      expect(product.product_image).to have_received(:clear)
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
      fulfillment = spy("fulfillment")
      product = build_stubbed(:product, github_team: "example")
      allow(GithubFulfillment).to receive(:new).with(product, user).
        and_return(fulfillment)

      product.fulfill(user)

      expect(fulfillment).to have_received(:fulfill)
    end
  end
end
