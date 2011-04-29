Workshops::Application.routes.draw do
  root :to => 'sections#index'

  match '/admin' => 'admin/courses#index', :as => :admin

  namespace :admin do
    resources :courses do
      resources :sections
      resources :teachers
      resources :follow_ups
    end
    resources :coupons
    resources :controlelr
    resources :sections do
      resources :registrations
    end
  end

  resources :sections do
    resources :registrations
    resources :redemptions
  end

  resources :courses do
    resources :sections do
      resources :registrations
    end
    resources :follow_ups
  end

  resource :session, :controller => 'sessions'

  match '/fairhaven' => 'high_voltage/pages#show', :as => :fairhaven, :id => 'fairhaven'
  match '/fairhaven/registered' => 'high_voltage/pages#show', :as => :fairhaven_registered, :id => 'fairhaven-registered'
  match '/fairhaven/resources' => 'high_voltage/pages#show', :as => :fairhaven_resources, :id => 'fairhaven-resources'
end
