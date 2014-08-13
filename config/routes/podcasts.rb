get "/podcast/articles" => "articles#index", id: :podcast

get "/podcast.xml" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots.xml")
get "/podcast" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots")
get "/podcast/:id" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots/%{id}")
get "/podcasts" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots")
get "/podcasts/:id" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots/%{id}")
get "/giantrobots.xml" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots.xml")
get "/giantrobots" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots")
get "/giantrobots/:id.mp3" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots/%{id}.mp3")
get "/giantrobots/:id" =>
  redirect("http://podcasts.thoughtbot.com/giantrobots/%{id}")
get "/buildphase.xml" =>
  redirect("http://podcasts.thoughtbot.com/buildphase.xml")
get "/buildphase" =>
  redirect("http://podcasts.thoughtbot.com/buildphase")
get "/buildphase/:id.mp3" =>
  redirect("http://podcasts.thoughtbot.com/buildphase/%{id}.mp3")
get "/buildphase/:id" =>
  redirect("http://podcasts.thoughtbot.com/buildphase/%{id}")
