require 'spec_helper'

describe Product do
  context '#alternates' do
    it 'is empty' do
      product = Product.new

      result = product.alternates

      expect(result).to eq []
    end
  end

  context 'purchase_for' do
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
end
