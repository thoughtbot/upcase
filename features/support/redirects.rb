rails_app = Capybara.app
Capybara.app = lambda do |env|
  if env['SERVER_NAME'].include?('www.example.com')
    rails_app.call(env)
  else
    [200, { 'Content-type' => 'text/html' }, ["Current location: #{env['PATH_INFO']} on #{env['SERVER_NAME']}"]]
  end
end
