require "rack/rewrite"

Rails.configuration.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
  def licenseable_id_url_for(licenseable)
    %r{/#{licenseable}/\d+-(.+)(\?.*)?}
  end

  r301 licenseable_id_url_for("products"), "/$1$2"
  r301 licenseable_id_url_for("screencasts"), "/$1$2"
  r301 licenseable_id_url_for("shows"), "/$1$2"
  r301 licenseable_id_url_for("workshops"), "/$1$2"

  # Upcase content
  r301 "/5by5", "/design-for-developers"
  r301 "/d4d-resources", "/design-for-developers-resources"
  r301 "/gettingstartedwithios", "/getting-started-with-ios-development?utm_source=podcast"
  r301 "/live", "https://forum.upcase.com"
  r301 "/prime", "/"
  r301 "/subscribe", "/"
  r301 "/dashboard", "/practice"
  r301 "/test-driven+development", "/testing"
  r301 "/test-driven+development/resources", "/testing"
  r301 "/clean+code", "/clean-code"
  r301 "/clean+code/resources", "/clean-code"
  r301 "/ruby", "/rails"
  r301 "/rubymotion", "/ios"
  r301 "/swift", "/ios"
  r301 "/git", "/workflow"
  r301 "/heroku", "/workflow"
  r301 "/sql", "/workflow"
  r301 "/unix", "/workflow"
  r301 "/typography", "/design"
  r301 "/visual-principles", "/design"
  r301 "/web+design", "/design"
  r301 "/grids", "/design"
  r301 "/html-css", "/design"
  r301 "/sass", "/design"
  r301 "/products", "/practice"
  r301 "/users/new", "/join"
  r301 "/sign_up", "/join"
  r301 "/trails", "/practice"

  # Books
  r301 "/backbone-js-on-rails", "https://gumroad.com/l/backbone-js-on-rails"
  r301 "/geocoding-on-rails", "https://gumroad.com/l/geocoding-on-rails"
  r301 "/ios-on-rails", "https://gumroad.com/l/ios-on-rails"
  r301 "/ios-on-rails-beta", "https://gumroad.com/l/ios-on-rails"
  r301 "/ruby-science", "https://gumroad.com/l/ruby-science"

  # Videos
  r301 "/videos/vim-for-rails-developers", "https://www.youtube.com/watch?v=9J2OjH8Ao_A"
  r301 "/humans-present/oss", "https://www.youtube.com/watch?v=VMBhumlUP-A"
  r301 "/pages/tmux", "https://www.youtube.com/watch?v=CKC8Ph-s2F4"

  # Dynamic
  r301 %r{^/(.+)/articles}, "https://robots.thoughtbot.com/tags/$1"
  r301 %r{^/courses/(.+)}, "/$1"
  r301 %r{^/products/(.+)/purchases/(.*)}, "/purchases/$2"
  r301 %r{^/workshops/(.+)}, "/$1"
  r301 %r{^/([^/]+)/resources}, "/$1"

  if Rails.env.production? || Rails.env.staging?
    r301 %r{^/products/(10|12)\D}, "/test-driven-rails"
    r301 %r{^/products/(9|11)\D}, "/design-for-developers"
    r301 "/products/4", "https://www.youtube.com/watch?v=CKC8Ph-s2F4"
    r301 "/products/14", "/"
    r301 "/products/14-prime", "/"
  end

  # Podcasts
  r301 "/podcast.xml", "http://podcasts.thoughtbot.com/giantrobots.xml"
  r301 "/podcast", "http://podcasts.thoughtbot.com/giantrobots"
  r301 "/podcasts", "http://podcasts.thoughtbot.com/giantrobots"
  r301 "/giantrobots.xml", "http://podcasts.thoughtbot.com/giantrobots.xml"
  r301 "/giantrobots", "http://podcasts.thoughtbot.com/giantrobots"
  r301 "/buildphase.xml", "http://podcasts.thoughtbot.com/buildphase.xml"
  r301 "/buildphase", "http://podcasts.thoughtbot.com/buildphase"

  r301 %r{^/buildphase/(.*).mp3}, "http://podcasts.thoughtbot.com/buildphase/$1.mp3"
  r301 %r{^/giantrobots/(.*).mp3}, "http://podcasts.thoughtbot.com/giantrobots/$1.mp3"
  r301 %r{^/podcast/(.*)}, "http://podcasts.thoughtbot.com/giantrobots/$1"
  r301 %r{^/podcasts/(.*)}, "http://podcasts.thoughtbot.com/giantrobots/$1"
  r301 %r{^/buildphase/(.*)}, "http://podcasts.thoughtbot.com/buildphase/$1"
  r301 %r{^/giantrobots/(.*)}, "http://podcasts.thoughtbot.com/giantrobots/$1"
end
