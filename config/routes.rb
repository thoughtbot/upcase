Workshops::Application.routes.draw do
  root :to => 'courses#index'

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

  resources :sections, :only => [:show] do
    resources :registrations, :only => [:index, :new, :create]
    resources :redemptions, :only => [:new]
  end

  resources :courses, :only => [:index, :show] do
    resources :follow_ups, :only => [:create]
  end

  resource :session, :controller => 'sessions'

  match '/fairhaven' => 'high_voltage/pages#show', :as => :fairhaven, :id => 'fairhaven'
  match '/fairhaven/registered' => 'high_voltage/pages#show', :as => :fairhaven_registered, :id => 'fairhaven-registered'
  match '/fairhaven/resources' => 'high_voltage/pages#show', :as => :fairhaven_resources, :id => 'fairhaven-resources'


  match '/intro-rails' => "high_voltage/pages#show", :as => :intro_rails, :id => "intro-rails"
  match '/everybody-codes' => "high_voltage/pages#show", :as => :everybody_codes, :id => "everybody-codes"

  match '/directions' => "high_voltage/pages#show", :as => :directions, :id => "directions"
  match '/group-training' => "high_voltage/pages#show", :as => :group_training, :id => "group-training"
end
