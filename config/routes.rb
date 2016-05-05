# NOTE: There are several rewrite rules defined in
# config/initializers/rack_rewrite.rb which run before these routes.
Upcase::Application.routes.draw do
  scope "upcase" do
    root to: "homes#show"
    get "/pages/:id" => 'high_voltage/pages#show', as: :page, format: false

    use_doorkeeper

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

        post(
          "exercises/:exercise_uuid/status" => "statuses#create",
          as: :exercise_status,
        )

        post(
          "videos/:video_wistia_id/status" => "statuses#create",
          as: :video_status,
        )
      end
    end

    get "/api/v1/me.json" => "api/v1/users#show", as: :resource_owner

    resources(
      :passwords,
      controller: "clearance/passwords",
      only: [:create, :new],
    )
    resource :session, controller: "sessions", only: [:create]

    resources :users, controller: "clearance/users", only: [] do
      resource(
        :password,
        controller: "clearance/passwords",
        only: [:create, :edit, :update],
      )
    end

    get "/join" => "subscriptions#new", as: :sign_up
    get "/join" => "subscriptions#new", as: :join
    get "/sign_in" => "sessions#new", as: "sign_in"
    delete "/sign_out" => "sessions#destroy", as: "sign_out"

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
      resource :authenticated_on_checkout, only: [:show]
      resources :checkouts, only: [:new, :create]
    end

    resources :repositories, only: [:index] do
      resource :collaboration, only: [:create]
    end

    get(
      ":id" => "repositories#show",
      as: :repository,
      constraints: SlugConstraint.new(Repository),
    )

    resource :search, only: [:show, :create]

    get(
      ":id" => "shows#show",
      as: :show,
      constraints: SlugConstraint.new(Show),
    )

    mount StripeEvent::Engine, at: "stripe-webhook"

    namespace :subscriber do
      resources :invoices, only: [:index, :show]
      resource :cancellation, only: [:new, :create]
      resource :discount, only: :create
      resource :reactivation, only: [:create]
      resource :resubscription, only: [:create]
    end

    namespace :beta do
      resources :offers, only: [] do
        resource :reply, only: :create
      end
    end

    get "/teams", to: "teams#new"
    resource :team, only: :edit

    resources :invitations, only: [:create, :destroy] do
      resources :acceptances, only: [:new, :create]
    end
    resources :memberships, only: [:destroy]

    get "/trails/completed" => "completed_trails#index", as: :completed_trails

    get(
      ":id" => "trails#show",
      as: :trail,
      constraints: SlugConstraint.new(Trail),
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
        only: [:create, :edit, :update],
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
      resource :auth_to_access, only: [:show]
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
      only: [:index, :show],
    )
    resources(
      :test_driven_rails_resources,
      path: "test-driven-rails-resources",
      only: [:index],
    )

    get "/practice" => "practice#show", as: :practice
    get "sitemap.xml" => "sitemaps#show", as: :sitemap, format: "xml"
    get ":id" => "topics#show", as: :topic
    get "/auth/:provider/callback", to: "auth_callbacks#create"
  end
end
