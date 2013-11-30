require 'spec_helper'

feature 'The products index' do
  scenario 'a visitor views the product index' do
    workshop = create(:workshop)
    screencast = create(:screencast)
    book = create(:book)

    visit products_path

    expect(page).to have_content('workshops')
    expect(page).to have_content('screencasts')
    expect(page).to have_content('books')
    within('.workshops') do
      expect(page).to have_content(workshop.name)
    end
    within('.screencasts') do
      expect(page).to have_content(screencast.name)
    end
    within('.reading') do
      expect(page).to have_css("a[title='#{book.name}']")
    end
  end
end
