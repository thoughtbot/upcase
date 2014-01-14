require 'spec_helper'

describe Product do
  describe '#alternates' do
    it 'is empty' do
      product = Product.new

      result = product.alternates

      expect(result).to eq []
    end
  end

  describe '#licenses_for' do
    it 'returns a subscriber license for a subscriber' do
      user = build_stubbed(:user)
      user.stubs(:has_active_subscription?).returns(true)
      product = build_stubbed(:product)

      licenses = product.licenses_for(user)

      license = licenses.first
      expect(licenses).to eq([license])
      expect(license.collection?).to eq(product.collection?)
      expect(license.offering_type).to eq(product.offering_type)
      expect(license.to_param).to eq(product.id.to_s)
      expect(license.sku).to eq(product.sku)
    end

    it 'returns individual and company purchase licenses for a user' do
      user = build_stubbed(:user)
      user.stubs(:has_active_subscription?).returns(false)
      product = build_stubbed(:product)

      licenses = product.licenses_for(user)
      individual, company = *licenses
      expect(licenses).to eq([individual, company])
      expect(individual.offering_type).to eq(product.offering_type)
      expect(individual.original_price).to eq(product.individual_price)
      expect(individual.price).to eq(product.individual_price)
      expect(individual.to_param).to eq(product.id.to_s)
      expect(individual.sku).to eq(product.sku)
      expect(individual.variant).to eq(:individual)
      expect(company.offering_type).to eq(product.offering_type)
      expect(company.original_price).to eq(product.company_price)
      expect(company.price).to eq(product.company_price)
      expect(company.to_param).to eq(product.id.to_s)
      expect(company.sku).to eq(product.sku)
      expect(company.variant).to eq(:company)
    end

    it 'returns licenses for a guest' do
      product = build_stubbed(:product)

      guest_licenses = product.licenses_for(nil)

      expect(guest_licenses).not_to be_empty
    end
  end

  describe 'purchase_for' do
    it 'returns the purchase when a user has purchased a product' do
      user = create(:user)
      purchase = create(:purchase, user: user)
      product = purchase.purchaseable

      expect(product.purchase_for(user)).to eq purchase
    end

    it 'returns nil when a user has not purchased a product' do
      user = create(:user)
      purchase = create(:purchase)
      product = purchase.purchaseable

      expect(product.purchase_for(user)).to be_nil
    end
  end

  describe '#collection?' do
    it 'returns false' do
      expect(Product.new).not_to be_collection
    end
  end

  describe '#fulfill' do
    it 'fulfills using GitHub with a GitHub team' do
      purchase = build_stubbed(:purchase)
      user = build_stubbed(:user)
      fulfillment = stub('fulfillment', :fulfill)
      product = build_stubbed(:product, github_team: 'example')
      GithubFulfillment.stubs(:new).with(purchase).returns(fulfillment)

      product.fulfill(purchase, user)

      fulfillment.should have_received(:fulfill)
    end
  end

  describe '#after_purchase_url' do
    it 'returns the purchase path' do
      purchase_path = 'http://example.com/purchase'
      product = build_stubbed(:product)
      purchase = build_stubbed(:purchase, purchaseable: product)
      controller = stub('controller')
      controller.stubs(:purchase_path).with(purchase).returns(purchase_path)

      after_purchase_url = product.after_purchase_url(controller, purchase)

      expect(after_purchase_url).to eq(purchase_path)
    end
  end
end
