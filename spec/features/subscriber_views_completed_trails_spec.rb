require "rails_helper"

RSpec.feature "Completed Trails" do
  scenario "user navigates to completed trails" do
    user = create(:user)
    complete_trail = create_trail_completed_by(user, at: 1.week.ago)
    just_finished_trail = create_trail_completed_by(user, at: 1.day.ago)
    sign_in_as user

    visit practice_path

    click_on "View all completed trails →"

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
