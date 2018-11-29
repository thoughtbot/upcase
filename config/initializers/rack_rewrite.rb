require "rack/rewrite"

Rails.configuration.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  def licenseable_id_url_for(licenseable)
    %r{/upcase/#{licenseable}/\d+-(.+)(\?.*)?}
  end

  not_thoughtbot_proxy = lambda do |rack_env|
    rack_env["HTTP_X_THOUGHTBOT_DOT_COM_PROXY"].blank?
  end

  if Rails.env.production?
    PATH_PATTERN = %r{^(?:/upcase)?(/.*)}
    REPLACEMENT_TEMPLATE = "https://#{ENV.fetch('APP_DOMAIN')}/upcase$1".freeze

    r301 PATH_PATTERN, REPLACEMENT_TEMPLATE, if: not_thoughtbot_proxy
  end

  r301 licenseable_id_url_for("products"), "/$1$2"
  r301 licenseable_id_url_for("screencasts"), "/$1$2"
  r301 licenseable_id_url_for("shows"), "/$1$2"
  r301 licenseable_id_url_for("workshops"), "/$1$2"

  # Upcase content
  r301 "/upcase/5by5", "/upcase/design-for-developers"
  r301 "/upcase/d4d-resources", "/upcase/design-for-developers-resources"
  r301 "/upcase/gettingstartedwithios", "/upcase/getting-started-with-ios-development?utm_source=podcast"
  r301 "/upcase/live", "https://forum.upcase.com"
  r301 "/upcase/prime", "/upcase/"
  r301 "/upcase/subscribe", "/upcase/"
  r301 "/upcase/dashboard", "/upcase/practice"
  r301 "/upcase/test-driven+development", "/upcase/testing"
  r301 "/upcase/test-driven+development/resources", "/upcase/testing"
  r301 "/upcase/clean+code", "/upcase/clean-code"
  r301 "/upcase/clean+code/resources", "/upcase/clean-code"
  r301 "/upcase/ruby", "/upcase/rails"
  r301 "/upcase/rubymotion", "/upcase/ios"
  r301 "/upcase/swift", "/upcase/ios"
  r301 "/upcase/git", "/upcase/workflow"
  r301 "/upcase/heroku", "/upcase/workflow"
  r301 "/upcase/sql", "/upcase/workflow"
  r301 "/upcase/unix", "/upcase/workflow"
  r301 "/upcase/typography", "/upcase/design"
  r301 "/upcase/visual-principles", "/upcase/design"
  r301 "/upcase/web+design", "/upcase/design"
  r301 "/upcase/grids", "/upcase/design"
  r301 "/upcase/html-css", "/upcase/design"
  r301 "/upcase/sass", "/upcase/design"
  r301 "/upcase/products", "/upcase/practice"
  r301 "/upcase/users/new", "/upcase/join"
  r301 "/upcase/sign_up", "/upcase/join"
  r301 "/upcase/join", "/upcase/practice"
  r301 "/upcase/trails", "/upcase/practice"
  r301 "/upcase/pages/landing", "/upcase/join"
  r301 "/upcase/testing-fundamentals", "/upcase/rails-testing-exercises"

  # Books
  r301 "/upcase/backbone-js-on-rails", "https://gumroad.com/l/backbone-js-on-rails"
  r301 "/upcase/geocoding-on-rails", "https://gumroad.com/l/geocoding-on-rails"
  r301 "/upcase/ios-on-rails", "https://gumroad.com/l/ios-on-rails"
  r301 "/upcase/ios-on-rails-beta", "https://gumroad.com/l/ios-on-rails"
  r301 "/upcase/ruby-science", "https://gumroad.com/l/ruby-science"

  # Videos
  r301 "/upcase/videos/factory-girl", "/upcase/videos/factory-bot"
  r301 "/upcase/videos/vim-for-rails-developers", "https://www.youtube.com/watch?v=9J2OjH8Ao_A"
  r301 "/upcase/humans-present/oss", "https://www.youtube.com/watch?v=VMBhumlUP-A"
  r301 "/upcase/pages/tmux", "https://www.youtube.com/watch?v=CKC8Ph-s2F4"

  # Dynamic
  r301 %r{^/upcase/(.+)/articles}, "https://robots.thoughtbot.com/tags/$1"
  r301 %r{^/upcase/courses/(.+)}, "/upcase/$1"
  r301 %r{^/upcase/products/(.+)/purchases/(.*)}, "/upcase/purchases/$2"
  r301 %r{^/upcase/workshops/(.+)}, "/upcase/$1"
  r301 %r{^/upcase/([^/]+)/resources}, "/upcase/$1"

  if Rails.env.production?
    r301 %r{^/upcase/products/(10|12)\D}, "/upcase/test-driven-rails"
    r301 %r{^/upcase/products/(9|11)\D}, "/upcase/design-for-developers"
    r301 "/upcase/products/4", "https://www.youtube.com/watch?v=CKC8Ph-s2F4"
    r301 "/upcase/products/14", "/upcase/"
    r301 "/upcase/products/14-prime", "/upcase/"
  end

  # Podcasts
  r301 "/upcase/podcast.xml", "http://podcasts.thoughtbot.com/giantrobots.xml"
  r301 "/upcase/giantrobots.xml", "http://podcasts.thoughtbot.com/giantrobots.xml"
  r301 "/upcase/buildphase.xml", "http://podcasts.thoughtbot.com/buildphase.xml"
  r301 %r{^/upcase/(buildphase|giantrobots)/(.*)}, "http://$1.fm/$2"
  r301 %r{^/upcase/(buildphase|giantrobots)$}, "http://$1.fm"
  r301 %r{^/upcase/podcasts?$}, "http://giantrobots.fm"
  r301 %r{^/upcase/podcasts?/(.*)}, "http://giantrobots.fm/$1"
end
