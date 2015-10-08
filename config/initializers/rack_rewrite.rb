require "rack/rewrite"

Rails.configuration.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  def licenseable_id_url_for(licenseable)
    %r{/#{licenseable}/\d+-(.+)(\?.*)?}
  end

  r301 licenseable_id_url_for("products"), "/$1$2"
  r301 licenseable_id_url_for("screencasts"), "/$1$2"
  r301 licenseable_id_url_for("shows"), "/$1$2"
  r301 licenseable_id_url_for("workshops"), "/$1$2"
end
