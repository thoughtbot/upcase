ActionController::Routing::Routes.draw do |map|
  map.admin '/admin', :controller => :courses
  map.root :controller => :sections, :action => :index

  map.resources :sections, :only => [:index, :show] do |sections|
    sections.resources :registrations, :only => [:index, :new, :create]
    sections.resources :redemptions, :only => [:new]
  end

  map.resources :courses do |courses|
    courses.resources :sections, :only => [:new, :create, :edit, :update] do |sections|
      sections.resources :registrations, :only => [:new]
    end
    courses.resources :teachers, :only => [:new, :create]
    courses.resources :follow_ups, :only => [:create, :destroy]
  end

  map.namespace :admin do |admin|
    map.resources :coupons
    admin.resources :sections, :only => [] do |section|
      section.resources :registrations, :only => [:new, :create]
    end
  end

  HighVoltage::Routes.draw(map)
  Clearance::Routes.draw(map)

  map.fairhaven '/fairhaven', :controller => "high_voltage/pages", :action => "show", :id => "fairhaven"
  map.fairhaven_registered '/fairhaven/registered', :controller => "high_voltage/pages", :action => "show", :id => "fairhaven-registered"
  map.fairhaven_resources '/fairhaven/resources', :controller => "high_voltage/pages", :action => "show", :id => "fairhaven-resources"
end
