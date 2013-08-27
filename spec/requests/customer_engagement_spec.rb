require 'spec_helper'

feature 'Subscriber engagement' do
  scenario 'An admin views a user with 0 engagement' do
    user_with_zero_engagement = create(:subscription).user

    admin = create(:admin)
    visit subscriber_engagements_path(as: admin)

    expect(page).to have_content('Subscriber Engagement Index')

    within('.engagement-score') do
      expect(page).to have_content("0")
    end
  end

  scenario 'An admin views a user who has taken 3 workshops' do
    user = create(:subscription).user
    3.times do
      create_subscriber_purchase(:section, user)
    end

    admin = create(:admin)
    visit subscriber_engagements_path(as: admin)

    within('.workshops-taken') do
      expect(page).to have_content("3")
    end
    within('.engagement-score') do
      expect(page).to have_content("80")
    end
    within('.last-workshop-taken-date') do
      expect(page).to have_content(Time.zone.today.to_s)
    end
  end
end
