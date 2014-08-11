require "rails_helper"

describe Product do
  it { should have_many(:licenses) }
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

  describe '#fulfill' do
    it 'fulfills using GitHub with a GitHub team' do
      license = build_stubbed(:license)
      user = build_stubbed(:user)
      fulfillment = stub('fulfillment', :fulfill)
      product = build_stubbed(:product, github_team: 'example')
      GithubFulfillment.stubs(:new).with(license).returns(fulfillment)

      product.fulfill(license, user)

      expect(fulfillment).to have_received(:fulfill)
    end
  end
end
