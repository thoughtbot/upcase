require 'mile_marker'
ActionView::Base.send :include, Thoughtbot::MileMarkerHelper
ActionController::Base.send :include, Thoughtbot::MileMarkerHelper
ActionController::Base.send :after_filter, :add_initialize_mile_marker