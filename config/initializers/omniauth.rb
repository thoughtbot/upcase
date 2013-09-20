Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, GITHUB_KEY, GITHUB_SECRET, scope: 'user:email'
end
