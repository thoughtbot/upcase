Workshops::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'admin'

  root to: 'topics#index'

  match '/pages/tmux' => redirect('/products/4-humans-present-tmux')

  if Rails.env.staging? || Rails.env.production?
    match '/products/:id' => redirect('/workshops/18-test-driven-rails'),
      constraints: { id: /(10|12).*/ }
    match '/products/:id' => redirect('/workshops/19-design-for-developers'),
      constraints: { id: /(9|11).*/ }
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
    resources :purchases, only: [:new, :create]
  end
  match '/products/:id/purchases/:lookup' => redirect("/purchases/%{lookup}")

  resources :purchases, only: [:show] do
    resources :videos, only: [:index, :show]
    member do
      get 'paypal'
      get 'watch'
    end
  end

  namespace :subscriber do
    resources :purchases, only: :create
  end

  resources :episodes, path: 'podcast', only: [:index, :show]
  match '/podcasts' => redirect("/podcast")
  match '/podcasts/:id' => redirect("/podcast/%{id}")

  resources :design_for_developers_resources, path: 'design-for-developers-resources', only: [:index, :show]
  resources :test_driven_rails_resources, path: 'test-driven-rails-resources', only: [:index]
  match '/d4d-resources' => redirect('/design-for-developers-resources')

  resources :topics, only: :index

  resources :articles, only: :show

  namespace :reports do
    resource :purchases_charts, only: :show
  end

  match '/auth/:provider/callback', to: 'auth_callbacks#create'

  match '/watch' => 'high_voltage/pages#show', as: :watch, id: 'watch'
  match '/directions' => "high_voltage/pages#show", as: :directions, id: "directions"
  match '/group-training' => "high_voltage/pages#show", as: :group_training, id: "group-training"
  match '/humans-present/oss' => "high_voltage/pages#show", as: :humans_present_oss, id: "humans-present-oss"

  match '/backbone-js-on-rails' => redirect("/products/1-backbone-js-on-rails")
  match '/5by5' => redirect('/workshops/19-design-for-developers?utm_source=5by5')

  match '/rubyist-booster-shot' => "high_voltage/pages#show", as: :rubyist_booster_shot, id: "rubyist-booster-shot"

  match '/my_account' => 'users#update', as: 'my_account', via: :put
  match '/my_account' => 'users#edit', as: 'my_account'
  match '/sign_up' => 'users#new', as: 'sign_up'
  match '/sign_in' => 'sessions#new', as: 'sign_in'

  mount Split::Dashboard, at: 'split'

  get ':id' => 'topics#show', as: :topic
  match '/:id/articles' => 'articles#index', as: 'topic_articles'
end
