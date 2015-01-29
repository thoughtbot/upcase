require "rails_helper"

feature "Subscriber views completed trails" do
  scenario "completed and incompleted trails are separated" do

    completed_trail = create(:trail, :published, :completed)
    incomplete_trail = create(:trail, :published)
    user = completed_trail.users.last
    sign_in_as user

    visit practice_path

    within ".completed-trails" do
      expect(page).to have_content(completed_trail.name)
      expect(page).to have_no_content(incomplete_trail.name)
    end

    within ".active-trails" do
      expect(page).to have_no_content(completed_trail.name)
      expect(page).to have_content(incomplete_trail.name)
    end
  end
end
