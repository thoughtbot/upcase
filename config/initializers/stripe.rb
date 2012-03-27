if Rails.env.production?
  Stripe.api_key = "BMuoTwgSB9xBe86unDplhvfGy1pDRcRP"
  STRIPE_PUBLIC_KEY = "pk_dS1rNV9KKlKqKkgnXzXYPdYzwM228"
else
  Stripe.api_key = "OoWSewdaxiln4jR1kp5IoKwOk55YIH7A"
  STRIPE_PUBLIC_KEY = "pk_IUggbBONd079p5jCloGEijOFRBDnq"
end
