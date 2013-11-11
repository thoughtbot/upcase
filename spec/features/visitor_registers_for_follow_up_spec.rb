require 'spec_helper'

feature 'Registering for a followup' do
  scenario 'request a follow up with no scheduled section' do
    section = create(:past_section)

    visit workshop_path(section.workshop)
    submit_follow_up('foo@example.com')

    expect(current_path).to eq workshop_path(section.workshop)

    create(:future_section, workshop: section.workshop)

    expect_to_receive_follow_up_email('foo@example.com', section.workshop)
  end

  scenario 'Request a follow up with a scheduled section' do
    section = create(:future_section)

    visit workshop_path(section.workshop)
    submit_follow_up('foo@example.com')

    expect(current_path).to eq workshop_path(section.workshop)
    expect(page).to have_content 'We will contact you when we schedule'
  end

  scenario 'Request a follow up with invalid email' do
    section = create(:past_section)

    visit workshop_path(section.workshop)
    submit_follow_up('')

    expect_to_see_email_failure

    submit_follow_up('yes!!')

    expect_to_see_email_failure
  end

  scenario 'Request a follow up with invalid email on a scheduled section' do
    section = create(:future_section)

    visit workshop_path(section.workshop)
    submit_follow_up('')

    expect_to_see_email_failure

    submit_follow_up('yes!!')

    expect_to_see_email_failure
  end

  def submit_follow_up(email_address)
    fill_in 'follow_up_email', with: email_address
    click_button 'Submit'
  end

  def expect_to_see_email_failure
    expect(page).to have_content 'Could not save follow up. Please check your email address.'
  end

  def expect_to_receive_follow_up_email(email_address, workshop)
    expect(ActionMailer::Base.deliveries).not_to be_empty

    result = ActionMailer::Base.deliveries.any? do |email|
      email.to == [email_address] &&
        email.subject =~ /#{workshop.name} workshop has been scheduled/i
    end

    expect(result).to be_true
  end
end
