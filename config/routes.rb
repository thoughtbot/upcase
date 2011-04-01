ActionController::Routing::Routes.draw do |map|
  map.admin '/admin', :controller => 'admin/courses'
  map.root :controller => :sections, :action => :index

  map.namespace :admin do |admin|
    admin.resources :courses do |courses|
      courses.resources :sections, :only => [:new, :create, :edit, :update]
      courses.resources :teachers, :only => [:new, :create]
      courses.resources :follow_ups, :only => [:create, :destroy]
    end
    admin.resources :coupons, :controlelr
    admin.resources :sections, :only => [] do |section|
      section.resources :registrations, :only => [:new, :create]
    end
  end

  map.resources :sections, :only => [:index, :show] do |sections|
    sections.resources :registrations, :only => [:index, :new, :create]
    sections.resources :redemptions, :only => [:new]
  end

  map.resources :courses, :only => [:show] do |courses|
    courses.resources :sections, :only => [] do |sections|
      sections.resources :registrations, :only => [:new, :create]
    end
    courses.resources :follow_ups, :only => [:create]
  end

  HighVoltage::Routes.draw(map)

  map.resource :session, :controller => 'sessions'
  Clearance::Routes.draw(map)

  map.fairhaven '/fairhaven', :controller => "high_voltage/pages", :action => "show", :id => "fairhaven"
  map.fairhaven_registered '/fairhaven/registered', :controller => "high_voltage/pages", :action => "show", :id => "fairhaven-registered"
  map.fairhaven_resources '/fairhaven/resources', :controller => "high_voltage/pages", :action => "show", :id => "fairhaven-resources"
end
