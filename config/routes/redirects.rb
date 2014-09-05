get "/pages/tmux" => redirect("https://www.youtube.com/watch?v=CKC8Ph-s2F4")
get "/5by5" => redirect("/design-for-developers?utm_source=5by5")
get "/live" => redirect(OfficeHours.url)
get "/humans-present/oss" => redirect(
  "https://www.youtube.com/watch?v=VMBhumlUP-A"
)
get "/backbone.js" => redirect("/backbone")
get "/geocodingonrails" => redirect("/geocoding-on-rails")
get "/ios-on-rails" => redirect("/ios-on-rails-beta")
get "/products/:id/purchases/:lookup" => redirect("/purchases/%{lookup}")
get "/workshops/:id" => redirect("/video_tutorials/%{id}")
get "/courses.json" => redirect("/video_tutorials.json")
get "/courses/:id" => redirect("/video_tutorials/%{id}")
get "/prime" => redirect("/subscribe")
get "/d4d-resources" => redirect("/design-for-developers-resources")
get "/:id/articles" => redirect("http://robots.thoughtbot.com/tags/%{id}")

get(
  "/gettingstartedwithios" => redirect(
    "/video_tutorials/24-getting-started-with-ios-development?utm_source=podcast"
  )
)

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
