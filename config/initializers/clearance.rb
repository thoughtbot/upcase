Clearance.configure do |config|
  config.mailer_sender = "Upcase <#{ENV["SUPPORT_EMAIL"]}>"
  config.cookie_name = ENV["CLEARANCE_COOKIE_NAME"]
  config.cookie_domain = ENV["CLEARANCE_COOKIE_DOMAIN"]
  config.routes = false
  config.redirect_url = "/upcase"
  config.rotate_csrf_on_sign_in = true
end
