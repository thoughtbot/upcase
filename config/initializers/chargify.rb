if Rails.env.production?
  CHARGIFY_API_KEY = "29fGw6QMQGJCtPGO2nW-"
  CHARGIFY_URL = "thoughtbot-workshops.chargify.com"
else
  CHARGIFY_API_KEY = "29fGw6QMQGJCtPGO2nW-"
  CHARGIFY_URL = "thoughtbot-workshops-staging.chargify.com"
end

