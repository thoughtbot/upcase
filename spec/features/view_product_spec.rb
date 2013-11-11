require 'spec_helper'

feature 'Viewing products' do
  scenario 'of different types' do
    book = create(
      :book_product,
      name: 'Book',
      short_description: 'An awesome book'
    )
    video = create(
      :video_product,
      name: 'Video',
      short_description: 'An awesome video'
    )

    visit product_url(book)

    expect(page).not_to have_content 'includes support'
    expect_page_to_have_meta_description(book.short_description)
    expect_page_to_have_title('Book: a book by thoughtbot')

    visit product_url(video)

    expect(page).not_to have_content 'includes support'
    expect_page_to_have_meta_description(video.short_description)
    expect_page_to_have_title('Video: a video by thoughtbot')
  end

  scenario 'that are inactive' do
    product = create(:book_product, :inactive)

    visit product_path(product)

    expect(page).not_to have_content 'Purchase for Yourself'
    expect(page).to have_content(
      'This book is not currently available. Contact learn@thoughtbot.com'
    )
  end

  scenario 'online workshop with in-person alternate' do
    online = create(:online_workshop)
    in_person = create(:in_person_workshop, name: online.name)

    visit workshop_path(online)

    expect_to_see_workshop_link(in_person)
  end

  scenario 'online workshop without in-person alternate' do
    online = create(:online_workshop)

    visit workshop_path(online)

    expect_to_not_see_workshop_link
  end

  scenario 'in-person workshop with online alternate' do
    online = create(:online_workshop)
    in_person = create(:in_person_workshop, name: online.name)

    visit workshop_path(in_person)

    expect_to_see_workshop_link(online)
  end

  scenario 'in-person workshop without online alternate' do
    in_person = create(:in_person_workshop)

    visit workshop_path(in_person)

    expect_to_not_see_workshop_link
  end

  def expect_to_see_workshop_link(workshop)
    expect(find('.workshop-alert a')[:href]).to eq workshop_path(workshop)
  end
  
  def expect_to_not_see_workshop_link
    expect(page).not_to have_css('.workshop-alert')
  end
end
