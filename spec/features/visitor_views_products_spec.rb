require "rails_helper"

feature 'The products index' do
  scenario 'a visitor views the product index' do
    video_tutorial = create(:video_tutorial)

    visit products_path

    expect(page).to have_content('video tutorial')
    within('.video_tutorial') do
      expect(page).to have_content(video_tutorial.name)
    end
  end
end
