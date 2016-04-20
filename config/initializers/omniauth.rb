Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = "/upcase/auth"
  end

  provider :github, GITHUB_KEY, GITHUB_SECRET, scope: 'user:email'
end
