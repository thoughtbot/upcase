ActionController::Routing::Routes.draw do |map|
  map.root :controller => :sections, :action => :index

  map.resources :sections, :only => [:index,:show] do |sections|
    sections.resources :registrations, :only => [:index]
  end

  HighVoltage::Routes.draw(map)
  Clearance::Routes.draw(map)
end
