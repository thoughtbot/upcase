# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Workshops::Application

Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'thawtbawt'
end
