Clearance.configure do |config|
  config.mailer_sender = "Upcase <#{ENV["SUPPORT_EMAIL"]}>"
  config.password_strategy = Clearance::PasswordStrategies::SHA1
  config.cookie_name = ENV["CLEARANCE_COOKIE_NAME"]
  config.cookie_domain = ENV["CLEARANCE_COOKIE_DOMAIN"]
  config.routes = false
end
