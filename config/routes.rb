Workshops::Application.routes.draw do
  root :to => 'courses#index'

  resource :session, :controller => 'sessions'
  resources :sections, :only => [:show] do
    resources :registrations, :only => [:index, :new, :create]
    resources :redemptions, :only => [:new]
  end
  resources :courses, :only => [:index, :show] do
    resources :follow_ups, :only => [:create]
  end

  match '/admin' => 'admin/courses#index', :as => :admin
  namespace :admin do
    resources :courses do
      resource :position
      resources :sections
      resources :teachers
      resources :follow_ups
      resources :questions, :only => [:destroy]
    end
    resources :coupons
    resources :audiences
    resources :sections do
      resources :registrations
    end
  end

  match '/watch' => 'high_voltage/pages#show', :as => :watch, :id => 'watch'
  match '/fairhaven' => 'high_voltage/pages#show', :as => :fairhaven, :id => 'fairhaven'
  match '/fairhaven/registered' => 'high_voltage/pages#show', :as => :fairhaven_registered, :id => 'fairhaven-registered'
  match '/fairhaven/resources' => 'high_voltage/pages#show', :as => :fairhaven_resources, :id => 'fairhaven-resources'

  match '/intro-rails' => "high_voltage/pages#show", :as => :intro_rails, :id => "intro-rails"
  match '/everybody-codes' => "high_voltage/pages#show", :as => :everybody_codes, :id => "everybody-codes"

  match '/directions' => "high_voltage/pages#show", :as => :directions, :id => "directions"
  match '/group-training' => "high_voltage/pages#show", :as => :group_training, :id => "group-training"

  match '/backbone-js-on-rails' => "high_voltage/pages#show", :as => :backbone_js_on_rails, :id => "backbone-js-on-rails"
end
