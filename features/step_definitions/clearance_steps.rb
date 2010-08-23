# Database

Given /^no user exists with an email of "(.*)"$/ do |email|
  User.find_by_email(email).should be_nil
end

Given /^I signed up with "(.*)\/(.*)"$/ do |email, password|
  user = Factory :user,
    :email                 => email,
    :password              => password,
    :password_confirmation => password
end

Given /^I am signed up and confirmed as "(.*)\/(.*)"$/ do |email, password|
  user = Factory :email_confirmed_user,
    :email                 => email,
    :password              => password,
    :password_confirmation => password
end

# Session

Then /^I should be signed in$/ do
  current_user.should_not be_nil
end

Then /^I should be signed out$/ do
  current_user.should be_nil
end

When /^session is cleared$/ do
  cookies['_hedgehog_session'] = nil
end

Given /^I have signed in with "(.*)\/(.*)"$/ do |email, password|
  Given %{I am signed up and confirmed as "#{email}/#{password}"}
  And %{I sign in as "#{email}/#{password}"}
end

Given /^I am signed in as a member of the "([^\"]+)" account$/ do |account_name|
  account = Account.find_by_name!(account_name)
  user = Factory(:user, :account => account)
  sign_in_as user
end

Given /^I am signed in as a member of the "([^\"]+)" account with project "([^\"]+)"$/ do |account_name, project_name|
  steps %{
    Given the following account exists:
      | name            |
      | #{account_name} |
    Given I am signed in as a member of the "#{account_name}" account
    And the following projects exist:
      | name            | account               |
      | #{project_name} | name: #{account_name} |
    And I am a member of the following projects:
      | project         |
      | #{project_name} |
  }
end

# Emails

Then /^a confirmation message should be sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  assert !user.confirmation_token.blank?
  assert !ActionMailer::Base.deliveries.empty?
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /confirm/i &&
    email.body =~ /#{user.confirmation_token}/
  end
  assert result
end

When /^I follow the confirmation link sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  visit new_user_confirmation_path(:user_id => user,
                                   :token   => user.confirmation_token)
end

Then /^a password reset message should be sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  assert !user.confirmation_token.blank?
  assert !ActionMailer::Base.deliveries.empty?
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /password/i &&
    email.body =~ /#{user.confirmation_token}/
  end
  assert result
end

When /^I follow the password reset link sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  visit edit_user_password_path(:user_id => user,
                                :token   => user.confirmation_token)
end

When /^I try to change the password of "(.*)" without token$/ do |email|
  user = User.find_by_email(email)
  visit edit_user_password_path(:user_id => user)
end

Then /^I should be forbidden$/ do
  assert_response :forbidden
end

# Actions

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  When %{I go to the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Sign in"}
end

When /^I sign out$/ do
  visit '/sign_out'
end

When /^I request password reset link to be sent to "(.*)"$/ do |email|
  When %{I go to the password reset request page}
  And %{I fill in "Email address" with "#{email}"}
  And %{I press "Reset password"}
end

When /^I update my password with "(.*)\/(.*)"$/ do |password, confirmation|
  And %{I fill in "Choose password" with "#{password}"}
  And %{I fill in "Confirm password" with "#{confirmation}"}
  And %{I press "Save this password"}
end

When /^I return next time$/ do
  When %{session is cleared}
  And %{I go to the homepage}
end

Given /^I am signed in as an admin of "([^"]*)"$/ do |account_name|
  account = Account.find_by_name(account_name) || Factory(:account, :name => account_name)
  user = Factory(:user, :account => account, :admin => true)
  sign_in_as user
end
