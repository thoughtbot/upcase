Split.configure do |config|
  config.allow_multiple_experiments = true
end

Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'J7t9VDGZZxPTb'
end

Split.redis = ENV['REDISTOGO_URL'] || 'redis://localhost:6379'
Split.redis.namespace = "split:workshops"
