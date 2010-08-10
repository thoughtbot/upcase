ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'clearance/sessions', :action => 'new'

  HighVoltage::Routes.draw(map)
  Clearance::Routes.draw(map)
end
