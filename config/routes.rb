Upcase::Application.routes.draw do
  root to: "homes#show"

  use_doorkeeper

  get "/5by5" => redirect("/design-for-developers?utm_source=5by5")
  get "/:id/articles" => redirect("http://robots.thoughtbot.com/tags/%{id}")
  get "/backbone-js-on-rails" => redirect("https://gumroad.com/l/backbone-js-on-rails")
  get "/courses/:id" => redirect("/%{id}")
  get "/d4d-resources" => redirect("/design-for-developers-resources")
  get "/geocoding-on-rails" => redirect("https://gumroad.com/l/geocoding-on-rails")
  get(
    "/gettingstartedwithios" => redirect(
      "/getting-started-with-ios-development?utm_source=podcast"
    )
  )
  get "/videos/vim-for-rails-developers" => redirect("https://www.youtube.com/watch?v=9J2OjH8Ao_A")
  get "/humans-present/oss" => redirect( "https://www.youtube.com/watch?v=VMBhumlUP-A")
  get "/ios-on-rails" => redirect("https://gumroad.com/l/ios-on-rails")
  get "/ios-on-rails-beta" => redirect("https://gumroad.com/l/ios-on-rails")
  get "/live" => redirect("http://forum.upcase.com")
  get "/pages/tmux" => redirect("https://www.youtube.com/watch?v=CKC8Ph-s2F4")
  get "/prime" => redirect("/")
  get "/subscribe" => redirect("/")
  get "/products/:id/purchases/:lookup" => redirect("/purchases/%{lookup}")
  get "/ruby-science" => redirect("https://gumroad.com/l/ruby-science")
  get "/workshops/:id" => redirect("/%{id}")
  get "/dashboard" => redirect("/practice")
  get "/test-driven+development" => redirect("/testing")
  get "/test-driven+development/resources" => redirect("/testing/resources")
  get "/clean+code" => redirect("/clean-code")
  get "/clean+code/resources" => redirect("/clean-code/resources")
  get "/ruby" => redirect("/rails")
  get "/rubymotion" => redirect("/ios")
  get "/swift" => redirect("/ios")
  get "/git" => redirect("/workflow")
  get "/heroku" => redirect("/workflow")
  get "/sql" => redirect("/workflow")
  get "/unix" => redirect("/workflow")
  get "/typography" => redirect("/design")
  get "/visual-principles" => redirect("/design")
  get "/web+design" => redirect("/design")
  get "/grids" => redirect("/design")
  get "/html-css" => redirect("/design")
  get "/sass" => redirect("/design")
  get "/products" => redirect("/practice")

  if Rails.env.staging? || Rails.env.production?
    get(
      "/products/:id" => redirect("/test-driven-rails"),
      constraints: { id: /(10|12).*/ }
    )
    get(
      "/products/:id" => redirect("/design-for-developers"),
      constraints: { id: /(9|11).*/ }
    )
    get(
      "/products/:id" => redirect("https://www.youtube.com/watch?v=CKC8Ph-s2F4"),
      constraints: { id: /(4).*/ }
    )
    get "/products/14" => redirect("/prime")
    get "/products/14-prime" => redirect("/prime")
  end

  scope module: "admin" do
    resources :users, only: [] do
      resource :masquerade, only: :create
    end
    resource :masquerade, only: :destroy
  end

  constraints Clearance::Constraints::SignedIn.new(&:admin?) do
    namespace :admin do
      resources :decks, only: [:new, :create, :show, :index] do
        resources :flashcards, only: [:new, :create, :edit, :update]
        resource :flashcard_preview, only: [:create]
        patch :flashcard_preview, to: "flashcard_previews#create"
      end
    end
  end

  mount RailsAdmin::Engine => "/admin", as: :admin

  namespace :api do
    namespace :v1 do
      resources :exercises, only: [:update]

      post "exercises/:exercise_uuid/status" => "statuses#create"
      post "videos/:video_wistia_id/status" => "statuses#create"
    end
  end

  get "/api/v1/me.json" => "api/v1/users#show", as: :resource_owner

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => redirect("/join")
  get "/users/new" => redirect("/join")

  resources :clips, only: [] do
    resource :download, only: [:show]
  end

  resources :decks, only: [:show, :index] do
    resources :flashcards, only: [:show]
    resource :results, only: [:show]
  end

  resources :flashcards, only: [] do
    resources :attempts, only: [:create, :update]
  end

  resources :exercises, only: [] do
    resource :trail, controller: "exercise_trails", only: [:show]
  end

  get "/purchases/:lookup" => "pages#show", id: "purchase-show"

  get "/pages/*id" => "pages#show", format: false
  get "/privacy" => "pages#show", as: :privacy, id: "privacy"
  get "/terms" => "pages#show", as: :terms, id: "terms"

  scope ":plan" do
    resources :checkouts, only: [:new, :create]
  end

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

  resources :repositories, only: [:index] do
    resource :collaboration, only: [:create]
  end

  get(
    ":id" => "repositories#show",
    as: :repository,
    constraints: SlugConstraint.new(Repository)
  )

  resource :search, only: [:show, :create]

  get(
    ":id" => "shows#show",
    as: :show,
    constraints: SlugConstraint.new(Show)
  )

  mount StripeEvent::Engine, at: "stripe-webhook"

  namespace :subscriber do
    resources :invoices, only: [:index, :show]
    resource :cancellation, only: [:new, :create]
    resource :discount, only: :create
  end

  get "/teams", to: "teams#new"
  resource :team, only: :edit

  resources :invitations, only: [:create, :destroy] do
    resources :acceptances, only: [:new, :create]
  end
  resources :memberships, only: [:destroy]

  get "/trails" => redirect("/practice")

  get "/trails/completed" => "completed_trails#index", as: :completed_trails

  get(
    ":id" => "trails#show",
    as: :trail,
    constraints: SlugConstraint.new(Trail)
  )

  get "/sign_up" => "users#new", as: "sign_up_app"
  get "/sign_in" => "sessions#new", as: "sign_in_app"

  get "/my_account" => "users#edit", as: "my_account"
  patch "/my_account" => "users#update", as: "edit_my_account"

  resources :users, controller: "users" do
    resources :notes, only: [:create, :edit, :update]
    resource(
      :password,
      controller: "passwords",
      only: [:create, :edit, :update]
    )
  end
  resources :passwords, controller: "passwords", only: [:create, :new]

  get "/vanity" => "vanity#index"
  get "/vanity/participant/:id" => "vanity#participant"
  post "/vanity/complete"
  post "/vanity/chooses"
  post "/vanity/reset"
  post "/vanity/add_participant"
  get "/vanity/image"

  resources :videos, only: [:index, :show] do
    resource :twitter_player_card, only: [:show]
    resources :completions, only: [:create], controller: "video_completions"
  end

  resource :annual_billing, only: :new
  resource :credit_card, only: [:update]
  resource :forum_sessions, only: :new
  resources :payments, only: [:new]
  resources :signups, only: [:create]
  resource :subscription, only: [:new, :edit, :update]
  resources :coupons, only: :show
  resources :topics, only: :index, constraints: { format: "css" }
  resources :onboardings, only: :create
  get "pages/welcome", to: "high_voltage#show", as: "welcome"

  resources(
    :design_for_developers_resources,
    path: "design-for-developers-resources",
    only: [:index, :show]
  )
  resources(
    :test_driven_rails_resources,
    path: "test-driven-rails-resources",
    only: [:index]
  )

  get "join" => "subscriptions#new", as: :join
  get "practice" => "practice#show", as: :practice
  get "explore" => "explore#show", as: :explore
  get "sitemap.xml" => "sitemaps#show", as: :sitemap, format: "xml"
  get ":id" => "topics#show", as: :topic
  get ":topic_id/resources" => redirect("/%{topic_id}")
  get "/auth/:provider/callback", to: "auth_callbacks#create"
end
