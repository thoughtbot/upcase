MAIL_SETTINGS = {
  address: "smtp.sendgrid.net",
  port: "587",
  authentication: :plain,
  user_name: ENV["SENDGRID_USERNAME"],
  password: ENV["SENDGRID_PASSWORD"],
  domain: "heroku.com"
}.freeze

if ENV["EMAIL_RECIPIENTS"]
  Mail.register_interceptor(
    RecipientInterceptor.new(ENV.fetch("EMAIL_RECIPIENTS"))
  )
end
