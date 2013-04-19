require 'spec_helper'

describe 'A Purchased book' do
  context 'GET /purchases/show for a book hosted on github', js: false do
    it 'references the github repository and links to the different formats' do
      client = stub(contents: 'filecontents')
      Octokit::Client.stubs(new: client)

      book = create(:github_book_product, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book, readers: [])

      visit purchase_path(purchase)

      expect(page).to have_content book.github_url
      expect(page).to have_content 'Start reading'
      expect(page).to have_css("a[href='#{purchase_download_path(purchase, format: 'pdf')}']")
      expect(page).to have_css("a[href='#{purchase_download_path(purchase, format: 'mobi')}']")
      expect(page).to have_css("a[href='#{purchase_download_path(purchase, format: 'epub')}']")

      click_link 'Download as EPUB'

      expect(page.response_headers['Content-Type']).to eq 'application/octet-stream'
      expect(page.response_headers['Content-Disposition']).to eq 'attachment; filename="book-title.epub"'
      expect(page.source).to eq 'filecontents'
    end
  end

  context 'GET /purchases/show for a book not hosted on github' do
    it 'does not reference the github repository or link to the different formats' do
      book = create(:book_product, name: 'Book title')
      purchase = create(:paid_purchase, purchaseable: book)

      visit purchase_path(purchase)

      expect(page).not_to have_content 'Start reading'
      expect(page).not_to have_css("a[href='#{purchase_download_path(purchase, format: 'pdf')}']")
      expect(page).not_to have_css("a[href='#{purchase_download_path(purchase, format: 'mobi')}']")
      expect(page).not_to have_css("a[href='#{purchase_download_path(purchase, format: 'epub')}']")
    end
  end
end
