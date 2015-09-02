class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(
      Rails.root.join("config/routes/#{routes_name}.rb")
    ))
  end
end

Upcase::Application.routes.draw do
  use_doorkeeper

  draw :redirects
  draw :admin
  draw :api
  draw :clearance
  draw :decks
  draw :exercises
  draw :pages
  draw :plan
  draw :podcasts
  draw :repositories
  draw :search
  draw :shows
  draw :stripe
  draw :subscriber
  draw :teams
  draw :trails
  draw :users
  draw :vanity
  draw :videos

  root to: "homes#show"

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
