require "rails_helper"

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
    within('.workshop') do
      expect(page).to have_content(workshop.name)
    end
    within('.screencast') do
      expect(page).to have_content(screencast.name)
    end
    within('.ebook') do
      expect(page).to have_css("a[title='#{book.name}']")
    end
    within('.weekly-iteration') do
      expect(page).to have_content(show.name)
    end
  end
end
