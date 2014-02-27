require 'spec_helper'

feature 'The products index' do
  scenario 'a visitor views the product index' do
    workshop = create(:workshop)
    screencast = create(:screencast)
    book = create(:book)
    show = create(:show)

    visit products_path

    expect(page).to have_content('workshop')
    expect(page).to have_content('screencast')
    expect(page).to have_content('book')
    within('.workshops') do
      expect(page).to have_content(workshop.name)
    end
    within('.screencasts') do
      expect(page).to have_content(screencast.name)
    end
    within('.reading') do
      expect(page).to have_css("a[title='#{book.name}']")
    end
    within('.shows') do
      expect(page).to have_content(show.name)
    end
  end
end
