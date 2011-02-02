ActionController::Routing::Routes.draw do |map|
  map.admin '/admin', :controller => :courses
  map.root :controller => :sections, :action => :index

  map.resources :sections, :only => [:index,:show] do |sections|
    sections.resources :registrations, :only => [:index]
  end

  map.resources :courses do |courses|
    courses.resources :sections, :only => [:new, :create, :edit, :update] do |sections|
      sections.resources :registrations, :only => [:new, :create]
    end
    courses.resources :teachers, :only => [:new, :create]
    courses.resources :follow_ups, :only => [:create, :destroy]
  end

  HighVoltage::Routes.draw(map)
  Clearance::Routes.draw(map)

  map.fairhaven '/fairhaven', :controller => "high_voltage/pages", :action => "show", :id => "fairhaven"
end
