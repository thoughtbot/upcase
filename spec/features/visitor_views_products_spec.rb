require "rails_helper"

feature 'The products index' do
  scenario 'a visitor views the product index' do
    video_tutorial = create(:video_tutorial)
    show = create(:show)

    visit products_path

    expect(page).to have_content('video tutorial')
    within('.video_tutorial') do
      expect(page).to have_content(video_tutorial.name)
    end
    expect(page).to have_content('book')
    within('.video_tutorial') do
      expect(page).to have_content(video_tutorial.name)
    end
    within('.weekly-iteration') do
      expect(page).to have_content(show.name)
    end
  end
end
