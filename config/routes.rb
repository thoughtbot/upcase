Workshops::Application.routes.draw do
  mount RailsAdmin::Engine => '/new_admin', :as => 'rails_admin'

  root to: 'topics#index'

  match '/pages/tmux' => redirect("/products/4-humans-present-tmux")

  resource :session, controller: 'sessions'
  resources :sections, only: [:show] do
    resources :registrations, only: [:index, :new, :create]
    resources :redemptions, only: [:new]
  end
  resources :courses, only: [:index, :show] do
    resources :follow_ups, only: [:create]
  end

  resources :products, only: [:index, :show] do
    resources :redemptions, only: [:new]
    resources :purchases, only: [:new, :create, :show] do
      resources :videos, only: [:show]
      member do
        get 'paypal'
        get 'watch'
      end
    end
  end

  resources :payments, only: [:create]
  resource :shopify, controller: 'shopify' do
    member do
      post 'order_paid'
    end
  end

  resources :topics, only: :index

  match '/admin' => 'admin/courses#index', as: :admin
  namespace :admin do
    resources :courses do
      resource :position
      resources :sections
      resources :follow_ups
      resources :questions, only: [:destroy]
    end
    resources :coupons
    resources :audiences
    resources :sections do
      resources :registrations
    end
    resources :teachers, except: :destroy
    resources :products, except: :destroy
    resources :purchases, only: :index
  end

  match '/auth/:provider/callback', to: 'auth_callbacks#create'

  match '/watch' => 'high_voltage/pages#show', as: :watch, id: 'watch'
  match '/directions' => "high_voltage/pages#show", as: :directions, id: "directions"
  match '/group-training' => "high_voltage/pages#show", as: :group_training, id: "group-training"
  match '/humans-present/oss' => "high_voltage/pages#show", as: :humans_present_oss, id: "humans-present-oss"

  match '/backbone-js-on-rails' => redirect("/products/1-backbone-js-on-rails")
  match '/5by5' => redirect('/products/9-design-for-developers?utm_source=5by5')

  match '/rubyist-booster-shot' => "high_voltage/pages#show", as: :rubyist_booster_shot, id: "rubyist-booster-shot"

  match '/my_account' => 'users#update', as: 'my_account', via: :put
  match '/my_account' => 'users#edit', as: 'my_account'
  match '/sign_up' => 'users#new', as: 'sign_up'
  match '/sign_in' => 'sessions#new', as: 'sign_in'

  mount Split::Dashboard, at: 'split'

  get ':id' => 'topics#show', as: :topic
  match '/:id/articles' => 'articles#index', as: 'topic_articles'
end
