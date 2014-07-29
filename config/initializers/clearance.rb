Clearance.configure do |config|
  config.mailer_sender = "Upcase <#{ENV["SUPPORT_EMAIL"]}>"
  config.password_strategy = Clearance::PasswordStrategies::SHA1
end
