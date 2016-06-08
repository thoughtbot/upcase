OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  'provider' => 'github',
  'uid' => 1,
  'info' => {
    'email' => 'user-from-github-omniauth@example.com',
    'name' => 'Test User',
    'nickname' => 'thoughtbot',
  }
})
