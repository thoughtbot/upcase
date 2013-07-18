Clearance.configure do |config|
  config.mailer_sender = 'thoughtbot <learn@thoughtbot.com>'
  config.password_strategy = Clearance::PasswordStrategies::SHA1
end
