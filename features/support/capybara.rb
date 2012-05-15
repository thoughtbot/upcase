# Capybara uses thin by default and falls back to WEBrick. We get odd test
# failures if we use, thin, so explicitly set the server to be WEBrick.
# https://github.com/jnicklas/capybara/blob/3a8cec7a63babc8c47be707e15601a1879f4eb01/lib/capybara.rb#L181
Capybara.server do |app, port|
  Rack::Handler::WEBrick.run(app, :Port => port, :AccessLog => [], :Logger => WEBrick::Log::new(nil, 0))
end
