# NOTE: There are several rewrite rules defined in
# config/initializers/rack_rewrite.rb which run before these routes.
Rails.application.routes.draw do
  get "/", to: redirect("/upcase")

  scope "upcase" do
    if ActiveModel::Type::Boolean.new.serialize(ENV["ENABLE_MARKETING_REDESIGN"])
      scope module: :marketing_redesign do
        root controller: :home, action: :show
        get "about-us", controller: :about, action: :show
        resources(
          :opportunities,
          only: %i[new create show],
          path: "contact-us",
          path_names: {
            new: "",
            show: "success"
          }
        )
        if Rails.env.development?
          get "library", controller: :library, action: :show
        end
      end

      scope "classic" do
        get "", to: "marketing#show"
        get "/about-us", to: "pages#show", id: "about_us"
      end
    else
      root to: "marketing#show"
      get "/about-us", to: "pages#show", id: "about_us"
    end

    get "the-weekly-iteration", to: "shows#show", id: "the-weekly-iteration"

    constraints Clearance::Constraints::SignedIn.new(&:admin?) do
      namespace :admin do
        resources :decks, only: [:new, :create, :show, :index] do
          resources :flashcards, only: [:new, :create, :edit, :update]
          resource :flashcard_preview, only: [:create]
          patch :flashcard_preview, to: "flashcard_previews#create"
        end
      end
    end

    namespace :api do
      namespace :v1 do
        post(
          "videos/:video_wistia_id/status" => "statuses#create",
          :as => :video_status
        )
      end
    end

    get "/api/v1/me.json" => "api/v1/users#show", :as => :resource_owner

    resources(
      :passwords,
      controller: "clearance/passwords",
      only: [:create, :new]
    )
    resource :session, controller: "sessions", only: [:create]

    resources :users, controller: "clearance/users", only: [] do
      resource(
        :password,
        controller: "clearance/passwords",
        only: [:create, :edit, :update]
      )
    end

    get "/unsubscribes/:token" => "unsubscribes#show", :as => :unsubscribe

    get "/sign_in" => "sessions#new", :as => "sign_in"
    delete "/sign_out" => "sessions#destroy", :as => "sign_out"

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

    get "/pages/:id", to: "high_voltage/pages#show", as: :page, format: false
    get "/privacy", to: "pages#show", as: :privacy, id: "privacy"
    get "/purchases/:lookup", to: "pages#show", id: "purchase-show"
    get "/terms", to: "pages#show", as: :terms, id: "terms"
    get "/pages/welcome", to: "pages#show", as: "welcome"
    get "/pre-sales/python", to: "pages#show", id: "pre_sale_python"

    resources :repositories, only: [:index] do
      resource :collaboration, only: [:create]
    end

    get(
      ":id" => "repositories#show",
      :as => :repository,
      :constraints => SlugConstraint.new(Repository)
    )

    resource :search, only: [:show, :create]

    get(
      ":id" => "shows#show",
      :as => :show,
      :constraints => SlugConstraint.new(Show)
    )

    get "/teams", to: "teams#new"
    resource :team, only: :edit

    resources :invitations, only: [:create, :destroy] do
      resources :acceptances, only: [:new, :create]
    end
    resources :memberships, only: [:destroy]

    get "/trails/completed" => "completed_trails#index", :as => :completed_trails

    get(
      ":id" => "trails#show",
      :as => :trail,
      :constraints => SlugConstraint.new(Trail)
    )

    get "/sign_up" => "users#new", :as => :sign_up

    get "/my_account" => "users#edit", :as => "my_account"
    patch "/my_account" => "users#update", :as => "edit_my_account"

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

    resources :videos, only: [:show] do
      resource :twitter_player_card, only: [:show]
      resources :completions, only: [:create], controller: "video_completions"
    end

    resource :forum_sessions, only: :new
    resources :onboardings, only: :create
    get "forum", to: redirect("https://forum.upcase.com"), as: "forum"

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

    get "/practice" => "practice#show", :as => :practice
    get "sitemap.xml" => "sitemaps#show", :as => :sitemap, :format => "xml"
    get ":id" => "topics#show", :as => :topic
    get "/auth/:provider/callback", to: "auth_callbacks#create"
  end
end
