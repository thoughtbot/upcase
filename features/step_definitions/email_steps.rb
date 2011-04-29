Then '"$email" receives a set your password link' do |email|
  user = User.find_by_email!(email)
  ActionMailer::Base.deliveries.should_not be_empty
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /Welcome/i &&
    email.body =~ /#{user.confirmation_token}/
  end
  result.should be
end

Then '"$email" does not receive a set your password link' do |email|
  user = User.find_by_email!(email)
  user.confirmation_token.should_not be_blank
  ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
      email.subject =~ /Welcome/i &&
      email.body =~ /#{user.confirmation_token}/
  end.should_not be, "Expected no 'set your password' email to be sent to #{user.email}"
end

When 'I follow the set your password link sent to "$email"' do |email|
  When %{I follow the password reset link sent to "#{email}"}
end

Then '"$email" does not receive a confirmation message' do |email|
  user = User.find_by_email(email)
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /confirm/i
  end
  result.should_not be
end

Then '"$email_address" receives a follow up email for "$course_title"' do |email_address, course_title|
  ActionMailer::Base.deliveries.should_not be_empty
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [email_address] &&
    email.subject =~ /#{course_title} workshop has been scheduled/i
  end
  result.should be
end

When 'emails are cleared' do
  ActionMailer::Base.deliveries.clear
end

Then '"$email_address" does not receive a follow up email for "$course_title"' do |email_address, course_title|
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [email_address] &&
    email.subject =~ /#{course_title} workshop has been scheduled/i
  end
  result.should_not be
end

Then '"$email_address" is notified that they are scheduled to teach "$course_title"' do |email_address, course_title|
  ActionMailer::Base.deliveries.should_not be_empty
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [email_address] &&
    email.subject =~ /You have been scheduled to teach #{course_title}/i
  end
  result.should be
end

Then '"$email_address" receives a registration notification email' do |email_address|
  ActionMailer::Base.deliveries.should be_empty
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [email_address] &&
    email.subject =~ /New registration notification/i
  end
  result.should be
end
