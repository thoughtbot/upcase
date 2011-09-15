if Rails.env.production?
  require 'rack/rewrite'

  Rails.configuration.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
    r301 %r{.*}, 'http://workshops.thoughtbot.com$&', :if => Proc.new { |rack_env|
      rack_env['SERVER_NAME'] != 'workshops.thoughtbot.com'
    }
  end
end
