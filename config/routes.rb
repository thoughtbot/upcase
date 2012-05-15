Workshops::Application.routes.draw do
  root to: 'courses#index'

  resource :session, controller: 'sessions'
  resources :sections, only: [:show] do
    resources :registrations, only: [:index, :new, :create]
    resources :redemptions, only: [:new]
  end
  resources :courses, only: [:index, :show] do
    resources :follow_ups, only: [:create]
  end

  resources :products, only: [:show] do
    resources :redemptions, only: [:new]
    resources :purchases, only: [:new, :create, :show] do
      member do
        get 'paypal'
      end
    end
  end

  resources :payments, only: [:create]
  resource :shopify, controller: 'shopify' do
    member do
      post 'order_paid'
    end
  end

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

  match '/watch' => 'high_voltage/pages#show', as: :watch, id: 'watch'
  match '/fairhaven' => 'high_voltage/pages#show', as: :fairhaven, id: 'fairhaven'
  match '/fairhaven/registered' => 'high_voltage/pages#show', as: :fairhaven_registered, id: 'fairhaven-registered'
  match '/fairhaven/resources' => 'high_voltage/pages#show', as: :fairhaven_resources, id: 'fairhaven-resources'

  match '/intro-rails' => "high_voltage/pages#show", as: :intro_rails, id: "intro-rails"
  match '/everybody-codes' => "high_voltage/pages#show", as: :everybody_codes, id: "everybody-codes"

  match '/directions' => "high_voltage/pages#show", as: :directions, id: "directions"
  match '/group-training' => "high_voltage/pages#show", as: :group_training, id: "group-training"
  match '/humans-present/oss' => "high_voltage/pages#show", as: :humans_present_oss, id: "humans-present-oss"

  match '/backbone-js-on-rails' => redirect("/products/1-backbone-js-on-rails")
  match '/vim' => redirect("/products/2-vim")
  match '/playbook' => redirect("/products/3-playbook")

  match '/rubyist-booster-shot' => "high_voltage/pages#show", as: :rubyist_booster_shot, id: "rubyist-booster-shot"
  match 'sign_in'  => 'sessions#new', as: 'sign_in'

  mount Split::Dashboard, at: 'split'
end
