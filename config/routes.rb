ActionController::Routing::Routes.draw do |map|
  map.root :controller => :sections, :action => :index

  HighVoltage::Routes.draw(map)
  Clearance::Routes.draw(map)
end
