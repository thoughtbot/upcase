require 'spec_helper'

feature 'Subscriber can contact his mentor' do
  scenario 'from the dashboard' do
    sign_in_as_user_with_mentoring_subscription
    mentor = @current_user.mentor

    expect(page).to have_content(I18n.t(
      'dashboards.show.contact_your_mentor',
      mentor_name: mentor.first_name
    ))
  end
end
