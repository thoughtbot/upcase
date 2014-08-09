require "rack/rewrite"

Rails.configuration.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  if Rails.env.production? || Rails.env.staging?
    r301(
      %r{.*},
      "http://#{ENV['APP_DOMAIN']}$&",
      if: proc { |rack_env| rack_env["SERVER_NAME"] != "#{ENV['APP_DOMAIN']}" }
    )
  end

  def licenseable_id_url_for(licenseable)
    %r{/#{licenseable}/\d+-(.+)(\?.*)?}
  end

  r301 licenseable_id_url_for("books"), "/$1$2"
  r301 licenseable_id_url_for("products"), "/$1$2"
  r301 licenseable_id_url_for("screencasts"), "/$1$2"
  r301 licenseable_id_url_for("shows"), "/$1$2"
  r301 licenseable_id_url_for("workshops"), "/$1$2"
end
