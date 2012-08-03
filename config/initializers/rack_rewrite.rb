if Rails.env.production?
  require 'rack/rewrite'

  Rails.configuration.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
    r301 %r{.*}, "http://#{HOST}$&", if: Proc.new { |rack_env|
      rack_env['SERVER_NAME'] != "HOST"
    }
  end
end
