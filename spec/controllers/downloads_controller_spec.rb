require 'spec_helper'

describe DownloadsController do
  describe '#show' do
    it 'responds with 404 for products with no file' do
      product = create(:product, github_url: nil)
      purchase = create(:purchase, purchaseable: product)

      get :show, purchase_id: purchase.to_param

      expect(response.response_code).to eq 404
    end
  end
end
