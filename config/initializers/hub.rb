require Rails.root.join("lib/hub")

Hub.configure do |config|
  config.url = ENV["HUB_API_URL"]
  config.token = ENV["HUB_API_TOKEN"]
end
