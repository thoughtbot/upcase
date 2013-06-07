require 'spec_helper'

describe 'A Purchased book' do
  context 'GET /purchases/show for a book' do
    it 'does not include support' do
      book = create(:book_product, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book)

      visit purchase_path(purchase)

      expect(page).not_to have_content 'includes support'
    end

    it 'includes support with a subscription' do
      book = create(:book_product, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book)

      sign_in_as_user_with_subscription
      visit purchase_path(purchase)

      expect(page).to have_content 'includes support'
    end
  end
end
