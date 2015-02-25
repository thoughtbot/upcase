require "rails_helper"

feature "Completed Trails" do
  scenario "subscriber navigates to completed trails" do
    user = create(:subscriber, :with_full_subscription)
    complete_trail = create_trail_completed_by(user, at: 1.week.ago)
    just_finished_trail = create_trail_completed_by(user, at: 1.day.ago)
    sign_in_as user

    visit root_path

    click_on "View completed trails →"

    expect(page).to have_content(complete_trail.name)
    expect(page).to have_content(just_finished_trail.name)
  end

  def create_trail_completed_by(user, at:)
    completed_exercise = create(:status, :completed, user: user).completeable
    trail = create(:trail, :published)
    Timecop.travel(at) do
      create(:status, :completed, completeable: trail, user: user)
    end
    create(:step, trail: trail, completeable: completed_exercise)
    trail
  end
end
