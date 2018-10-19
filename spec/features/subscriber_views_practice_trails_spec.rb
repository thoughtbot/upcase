require "rails_helper"

feature "user views completed trails" do
  scenario "completed and incompleted trails are separated" do
    completed_trail = create(:trail, :published, :completed)
    user = completed_trail.users.last
    just_finished_trail = create(:trail, :published)
    create(:status, :completed, completeable: just_finished_trail, user: user)
    incomplete_trail = create(:trail, :published)
    sign_in_as user

    visit practice_path

    within ".completed-trails" do
      expect(page).to have_content(just_finished_trail.name)
      expect(page).not_to have_content(incomplete_trail.name)
    end

    within ".incomplete-trails" do
      expect(page).not_to have_content(just_finished_trail.name)
      expect(page).to have_content(incomplete_trail.name)
    end

    expect(page).to have_no_content(completed_trail.name)
  end
end
