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


