Then '"$email" receives a set your password link' do |email|
  user = User.find_by_email(email)
  assert !user.confirmation_token.blank?
  assert !ActionMailer::Base.deliveries.empty?
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /Welcome/i &&
    email.body =~ /#{user.confirmation_token}/
  end
  assert result
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
  assert !result
end

Then '"$email_address" receives a follow up email for "$course_title"' do |email_address, course_title|
  assert !ActionMailer::Base.deliveries.empty?
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [email_address] &&
    email.subject =~ /#{course_title} workshop has been scheduled/i
  end
  assert result
end

When 'emails are cleared' do
  ActionMailer::Base.deliveries.clear
end

Then '"$email_address" does not receive a follow up email for "$course_title"' do |email_address, course_title|
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [email_address] &&
    email.subject =~ /#{course_title} workshop has been scheduled/i
  end
  assert !result
end
