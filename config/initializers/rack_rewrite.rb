if Rails.env.production? || Rails.env.staging?
  require 'rack/rewrite'

  Rails.configuration.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    r301 %r{.*}, "http://#{HOST}$&", if: Proc.new { |rack_env|
      rack_env['SERVER_NAME'] != "#{HOST}"
    }
  end
end
