get "/5by5" => redirect("/design-for-developers?utm_source=5by5")
get "/:id/articles" => redirect("http://robots.thoughtbot.com/tags/%{id}")
get "/backbone-js-on-rails" => redirect("https://gumroad.com/l/backbone-js-on-rails")
get "/courses.json" => redirect("/video_tutorials.json")
get "/courses/:id" => redirect("/video_tutorials/%{id}")
get "/d4d-resources" => redirect("/design-for-developers-resources")
get "/geocoding-on-rails" => redirect("https://gumroad.com/l/geocoding-on-rails")
get(
  "/gettingstartedwithios" => redirect(
    "/video_tutorials/24-getting-started-with-ios-development?utm_source=podcast"
  )
)
get "/humans-present/oss" => redirect( "https://www.youtube.com/watch?v=VMBhumlUP-A")
get "/ios-on-rails" => redirect("https://gumroad.com/l/ios-on-rails")
get "/ios-on-rails-beta" => redirect("https://gumroad.com/l/ios-on-rails")
get "/live" => redirect("http://forum.upcase.com")
get "/pages/tmux" => redirect("https://www.youtube.com/watch?v=CKC8Ph-s2F4")
get "/prime" => redirect("/")
get "/subscribe" => redirect("/")
get "/products/:id/purchases/:lookup" => redirect("/purchases/%{lookup}")
get "/ruby-science" => redirect("https://gumroad.com/l/ruby-science")
get "/workshops/:id" => redirect("/video_tutorials/%{id}")
get "/dashboard" => redirect("/practice")
get "/test-driven+development" => redirect("/testing")
get "/clean+code" => redirect("/clean-code")

if Rails.env.staging? || Rails.env.production?
  get(
    "/products/:id" => redirect("/video_tutorials/18-test-driven-rails"),
    constraints: { id: /(10|12).*/ }
  )
  get(
    "/products/:id" => redirect("/video_tutorials/19-design-for-developers"),
    constraints: { id: /(9|11).*/ }
  )
  get(
    "/products/:id" => redirect("https://www.youtube.com/watch?v=CKC8Ph-s2F4"),
    constraints: { id: /(4).*/ }
  )
  get "/products/14" => redirect("/prime")
  get "/products/14-prime" => redirect("/prime")
end
