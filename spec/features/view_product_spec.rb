require 'spec_helper'

feature 'Viewing products' do
  scenario 'of different types' do
    book = create(
      :book,
      name: 'Book',
      short_description: 'An awesome book'
    )
    screencast = create(
      :screencast,
      name: 'Video',
      short_description: 'An awesome video'
    )

    visit product_url(book)

    expect(page).not_to have_content 'includes support'
    expect_page_to_have_meta_description(book.short_description)
    expect_page_to_have_title('Book: a book by thoughtbot')

    visit product_url(screencast)

    expect(page).not_to have_content 'includes support'
    expect_page_to_have_meta_description(screencast.short_description)
    expect_page_to_have_title('Video: a screencast by thoughtbot')
  end

  scenario 'that are inactive' do
    product = create(:book, :inactive)

    visit product_path(product)

    expect(page).not_to have_content 'Purchase for Yourself'
    expect(page).to have_content(
      'This book is not currently available. Contact learn@thoughtbot.com'
    )
  end
end
