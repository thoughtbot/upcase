Workshops::Application.routes.draw do
  use_doorkeeper

  mount RailsAdmin::Engine => '/admin', :as => 'admin'

  root to: 'homes#show'

  get '/api/v1/me.json' => 'api/v1/users#show', as: :resource_owner
  namespace :api do
    namespace :v1 do
      resources :completions, only: [:index, :show, :create, :destroy]
    end
  end

  namespace :widgets do
    with_options only: :show do |route|
      route.resource :plan_churn
      route.resource :plan_ltv
      route.resource :plan_subscriber_count
      route.resource :projected_monthly_revenue
      route.resource :total_churn
      route.resource :total_new_subscriber_count
      route.resource :total_subscriber_count
    end
  end

  get '/pages/tmux' => redirect('/products/4-humans-present-tmux')

  if Rails.env.staging? || Rails.env.production?
    get '/products/:id' => redirect('/workshops/18-test-driven-rails'),
      constraints: { id: /(10|12).*/ }
    get '/products/:id' => redirect('/workshops/19-design-for-developers'),
      constraints: { id: /(9|11).*/ }
    get '/products/14' => redirect('/prime')
    get '/products/14-prime' => redirect('/prime')
  end

  resource :session, controller: 'sessions'

  resources :sections, only: [] do
    resources :purchases, only: [:new, :create]
    resources :redemptions, only: [:new]
  end

  get '/courses.json' => redirect('/workshops.json')
  get '/courses/:id' => redirect('/workshops/%{id}')
  resources :workshops, only: [:show] do
    resources :follow_ups, only: [:create]
  end

  resources :products, only: [:index, :show] do
    resources :redemptions, only: [:new]
    resources :purchases, only: [:new, :create]
  end
  get '/products/:id/purchases/:lookup' => redirect("/purchases/%{lookup}")

  resources :purchases, only: [:show] do
    resources :videos, only: [:show]
    member do
      get 'paypal'
    end
  end

  namespace :subscriber do
    resources :products, only: [] do
      resources :purchases, only: [:new, :create]
    end
    resources :sections, only: [] do
      resources :purchases, only: [:new, :create]
    end
    resources :invoices, only: [:index, :show]
    resource :cancellation, only: [:new, :create]
    resource :downgrade, only: :create
  end

  resource :subscription, only: [:new, :edit, :update]
  resource :credit_card, only: [:update]

  resources :individual_plans, only: [] do
    resources :purchases, only: [:new, :create]
    resources :stripe_redemptions, only: [:new]
  end

  resources :team_plans, only: [:index] do
    resources :purchases, only: [:new, :create]
    resources :stripe_redemptions, only: [:new]
  end

  get '/podcast.xml' => redirect('http://podcasts.thoughtbot.com/giantrobots.xml')
  get '/podcast' => redirect('http://podcasts.thoughtbot.com/giantrobots')
  get '/podcast/articles' => 'articles#index', id: 'podcast'
  get '/podcast/:id' => redirect("http://podcasts.thoughtbot.com/giantrobots/%{id}")
  get '/podcasts' => redirect('http://podcasts.thoughtbot.com/giantrobots')
  get '/podcasts/:id' => redirect("http://podcasts.thoughtbot.com/giantrobots/%{id}")
  get '/giantrobots.xml' => redirect('http://podcasts.thoughtbot.com/giantrobots.xml')
  get '/giantrobots' => redirect('http://podcasts.thoughtbot.com/giantrobots')
  get '/giantrobots/:id.mp3' => redirect("http://podcasts.thoughtbot.com/giantrobots/%{id}.mp3")
  get '/giantrobots/:id' => redirect("http://podcasts.thoughtbot.com/giantrobots/%{id}")
  get '/buildphase.xml' => redirect('http://podcasts.thoughtbot.com/buildphase.xml')
  get '/buildphase' => redirect('http://podcasts.thoughtbot.com/buildphase')
  get '/buildphase/:id.mp3' => redirect("http://podcasts.thoughtbot.com/buildphase/%{id}.mp3")
  get '/buildphase/:id' => redirect("http://podcasts.thoughtbot.com/buildphase/%{id}")

  resources :design_for_developers_resources, path: 'design-for-developers-resources', only: [:index, :show]
  resources :test_driven_rails_resources, path: 'test-driven-rails-resources', only: [:index]
  get '/d4d-resources' => redirect('/design-for-developers-resources')

  resources :topics, only: :index, path: 'trails'

  resources :bytes, only: [:index, :show]
  get '/articles/:id' => redirect("/bytes/%{id}")

  namespace :reports do
    resource :purchases_charts, only: :show
  end

  get '/auth/:provider/callback', to: 'auth_callbacks#create'

  resource :timeline, only: :show

  get "/pages/*id" => 'pages#show', format: false
  get '/prime' => 'pages#show', as: :prime, id: 'prime'
  get '/watch' => 'pages#show', as: :watch, id: 'watch'
  get '/privacy' => 'pages#show', as: :privacy, id: 'privacy'
  get '/terms' => 'pages#show', as: :terms, id: 'terms'
  get '/directions' => "pages#show", as: :directions, id: "directions"
  get '/group-training' => "pages#show", as: :group_training, id: "group-training"
  get '/humans-present/oss' => "pages#show", as: :humans_present_oss, id: "humans-present-oss"
  get '/backbone.js' => redirect('/backbone')
  get '/backbone-js-on-rails' => redirect('/products/1-backbone-js-on-rails')
  get '/geocoding-on-rails' => redirect('/products/22-geocoding-on-rails')
  get '/geocodingonrails' => redirect('/products/22-geocoding-on-rails')
  get '/5by5' => redirect('/workshops/19-design-for-developers?utm_source=5by5')
  get '/rubyist-booster-shot' => "pages#show", as: :rubyist_booster_shot, id: "rubyist-booster-shot"

  patch '/my_account' => 'users#update', as: 'edit_my_account'
  get '/my_account' => 'users#edit', as: 'my_account'
  resources :users, controller: 'users' do
    resources :notes, only: [:create, :edit, :update]
    resource :timeline, only: :show
  end
  get '/sign_up' => 'users#new', as: 'sign_up_app'
  get '/sign_in' => 'sessions#new', as: 'sign_in_app'
  resources :passwords, controller: 'passwords'
  resource :dashboard, only: :show

  mount Split::Dashboard, at: 'split'

  mount StripeEvent::Engine, at: 'stripe-webhook'

  resources 'bytes', only: :index

  get ':id' => 'topics#show', as: :topic
  get '/:id/articles' => 'articles#index', as: 'topic_articles'
  get '/:topic_id/bytes' => 'topics/bytes#index', as: 'topic_bytes'
end
