# coding: utf-8
require "rails_helper"

feature "Completed Trails" do
  let(:user) { create(:subscriber) }

  scenario "subscriber navigates to completed trails" do
    complete_trail = create_trail(completed_at: 1.week.ago)
    just_finished_trail = create_trail(completed_at: 1.day.ago)
    sign_in_as user

    visit root_path

    click_on "View completed trails →"

    expect(page).to have_content(complete_trail.name)
    expect(page).to have_content(just_finished_trail.name)
  end

  def create_trail(completed_at:)
    completed_exercise = create(:status, :completed, user: user).completeable
    trail = create(:trail, :published)
    Timecop.travel(completed_at) do
      create(:status, :completed, completeable: trail, user: user)
    end
    create(:step, trail: trail, completeable: completed_exercise)
    trail
  end
end
