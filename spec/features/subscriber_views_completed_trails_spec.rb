require "rails_helper"

feature "Completed Trails" do
  let(:user) { create(:subscriber) }

  scenario "subscriber navigates to completed trails" do
    complete_trail = create_trail(completed_at: 1.week.ago)
    just_finished_trail = create_trail(completed_at: 1.day.ago)
    sign_in_as user

    visit root_path

    expect(page).not_to have_content(complete_trail.name)
    expect(page).to have_content(just_finished_trail.name)

    click_on "View completed trails →"

    expect(page).to have_content(complete_trail.name)
    expect(page).to have_content(just_finished_trail.name)
  end

  def create_trail(completed_at:)
    trail = create(:trail, :published, name: "Trail #{completed_at}")
    Status.create!(
      user: user,
      completeable: trail,
      state: Status::COMPLETE,
      created_at: completed_at
    )
    trail
  end
end
