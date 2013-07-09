Workshops::Application.routes.draw do
  use_doorkeeper

  mount RailsAdmin::Engine => '/admin', :as => 'admin'

  root to: 'homes#show'

  match '/api/v1/me.json' => 'api/v1/users#show', as: :resource_owner
  namespace :api do
    namespace :v1 do
      resources :completions, only: [:index, :show, :create, :destroy]
    end
  end

  match '/pages/tmux' => redirect('/products/4-humans-present-tmux')

  if Rails.env.staging? || Rails.env.production?
    match '/products/:id' => redirect('/workshops/18-test-driven-rails'),
      constraints: { id: /(10|12).*/ }
    match '/products/:id' => redirect('/workshops/19-design-for-developers'),
      constraints: { id: /(9|11).*/ }
    match '/products/14' => redirect('/prime')
    match '/products/14-prime' => redirect('/prime')
  end

  resource :session, controller: 'sessions'

  resources :sections, only: [] do
    resources :purchases, only: [:new, :create]
    resources :redemptions, only: [:new]
  end

  get '/courses.json' => redirect('/workshops.json')
  get '/courses/:id' => redirect('/workshops/%{id}')
  resources :workshops, only: [:index, :show] do
    resources :follow_ups, only: [:create]
  end

  resources :products, only: [:index, :show] do
    resources :redemptions, only: [:new]
    resources :stripe_redemptions, only: [:new]
    resources :purchases, only: [:new, :create]
  end
  match '/products/:id/purchases/:lookup' => redirect("/purchases/%{lookup}")

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
  end

  resources :subscriptions, only: [:destroy, :update]

  resources :episodes, path: 'podcast', only: [:index, :show]
  match '/podcasts' => redirect("/podcast")
  match '/podcasts/:id' => redirect("/podcast/%{id}")

  resources :design_for_developers_resources, path: 'design-for-developers-resources', only: [:index, :show]
  resources :test_driven_rails_resources, path: 'test-driven-rails-resources', only: [:index]
  match '/d4d-resources' => redirect('/design-for-developers-resources')

  resources :topics, only: :index, path: 'trails'

  resources :bytes, only: [:index, :show]
  match '/articles/:id' => redirect("/bytes/%{id}")

  namespace :reports do
    resource :purchases_charts, only: :show
  end

  match '/auth/:provider/callback', to: 'auth_callbacks#create'

  get "/pages/*id" => 'pages#show', :as => :page, :format => false
  match '/prime' => 'pages#show', as: :prime, id: 'prime'
  match '/sale' => 'pages#show', as: :learnsale, id: 'learnsale'
  match '/watch' => 'pages#show', as: :watch, id: 'watch'
  match '/privacy' => 'pages#show', as: :privacy, id: 'privacy'
  match '/terms' => 'pages#show', as: :terms, id: 'terms'
  match '/directions' => "pages#show", as: :directions, id: "directions"
  match '/group-training' => "pages#show", as: :group_training, id: "group-training"
  match '/humans-present/oss' => "pages#show", as: :humans_present_oss, id: "humans-present-oss"
  match '/backbone-js-on-rails' => redirect("/products/1-backbone-js-on-rails")
  match '/5by5' => redirect('/workshops/19-design-for-developers?utm_source=5by5')
  match '/rubyist-booster-shot' => "pages#show", as: :rubyist_booster_shot, id: "rubyist-booster-shot"

  match '/my_account' => 'users#update', as: 'my_account', via: :put
  match '/my_account' => 'users#edit', as: 'my_account'
  match '/sign_up' => 'users#new', as: 'sign_up'
  match '/sign_in' => 'sessions#new', as: 'sign_in'
  resources :users, controller: 'users'
  resources :passwords, controller: 'passwords'

  mount Split::Dashboard, at: 'split'

  mount StripeEvent::Engine, at: 'stripe-webhook'

  resources 'bytes', only: :index

  get ':id' => 'topics#show', as: :topic
  match '/:id/articles' => 'articles#index', as: 'topic_articles'
  match '/:topic_id/bytes' => 'topics/bytes#index', as: 'topic_bytes'
end
