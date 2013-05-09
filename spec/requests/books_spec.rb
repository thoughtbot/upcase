require 'spec_helper'

describe 'A Purchased book' do
  context 'GET /purchases/show for a book hosted on github' do
    it 'references the github repository and links to the different formats' do
      book = create(:github_book_product, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book, github_usernames: [])

      visit purchase_path(purchase)

      expect(page).to have_content book.github_url
      expect(page).to have_content 'Start reading'
      expect(page).to have_css("a[href='http://github.com/thoughtbot/book-repo/blob/master/release/book-title.pdf?raw=true']")
      expect(page).to have_css("a[href='http://github.com/thoughtbot/book-repo/blob/master/release/book-title.pdf?raw=true']")
      expect(page).to have_css("a[href='http://github.com/thoughtbot/book-repo/blob/master/release/book-title.pdf?raw=true']")
    end
  end

  context 'GET /purchases/show for a book not hosted on github' do
    it 'does not reference the github repository or link to the different formats' do
      book = create(:book_product, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book)

      visit purchase_path(purchase)

      expect(page).not_to have_content 'Start reading'
      expect(page).not_to have_css("a[href='http://github.com/thoughtbot/book-repo/blob/master/release/book-title.pdf?raw=true']")
      expect(page).not_to have_css("a[href='http://github.com/thoughtbot/book-repo/blob/master/release/book-title.pdf?raw=true']")
      expect(page).not_to have_css("a[href='http://github.com/thoughtbot/book-repo/blob/master/release/book-title.pdf?raw=true']")
    end
  end

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
