require "rails_helper"

feature "Subscriber views completed trails" do
  scenario "completed and uncompleted trails are separated" do
    completed_trail = create(:trail, :published, :completed)
    incomplete_trail = create(:trail, :published)
    user = completed_trail.users.last
    sign_in_as user

    visit practice_path
    #save_and_open_page
    expect(page).to have_content(completed_trail.name)
    expect(page).to have_content(incomplete_trail.name)
  end
end
