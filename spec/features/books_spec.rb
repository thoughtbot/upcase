require 'spec_helper'

describe 'A Purchased book' do
  context 'GET /purchases/show for a book' do
    include ProductsHelper

    it 'does not include support' do
      book = create(:book, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book)

      visit purchase_path(purchase)

      expect(page).not_to have_content 'includes support'
    end

    it 'includes support with a subscription' do
      book = create(:book, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book)

      sign_in_as_user_with_subscription
      visit purchase_path(purchase)

      expect(page).to have_content 'includes support'
    end

    it 'includes a send to readmill button' do
      book = create(:book, :github, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book)

      visit purchase_path(purchase)

      readmill = find('a.send-to-readmill')
      expect(readmill['data-download-url']).to eq epub_url(book)
      expect(readmill['data-buy-url']).to eq product_url(book)
    end
  end
end
