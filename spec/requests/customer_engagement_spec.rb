require 'spec_helper'

feature 'Subscriber engagement' do
  scenario 'An admin views a user with 0 engagement' do
    user_with_zero_engagement = create(:subscription).user

    visit subscriber_engagements_path

    expect(page).to have_content('Subscriber Engagement Index')

    within('.engagement-score') do
      expect(page).to have_content("0")
    end
  end

  scenario 'An admin views a user who has taken 3 workshops' do
    user = create(:subscription).user
    3.times do
      create(:section_purchase, user: user)
    end

    visit subscriber_engagements_path

    within('.workshops-taken') do
      expect(page).to have_content("3")
    end
    within('.engagement-score') do
      expect(page).to have_content("80")
    end
    within('.last-workshop-taken-date') do
      expect(page).to have_content(Date.today.to_s)
    end
  end
end
