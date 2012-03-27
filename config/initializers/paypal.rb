if Rails.env.test?
  PAYPAL_USERNAME = ""
  PAYPAL_PASSWORD = ""
  PAYPAL_SIGNATURE = ""
else
  PAYPAL_USERNAME = "purchasing_api1.thoughtbot.com"
  PAYPAL_PASSWORD = "NJJDV9RS6Z3PL8LG"
  PAYPAL_SIGNATURE = "AGFLtEG6qkicR9BIyz2VureilJErAQ0TCpd6RiBrrCgcLa2pizcm-NtA"
end
