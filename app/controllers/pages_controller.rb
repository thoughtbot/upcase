class PagesController < HighVoltage::PagesController
  include HighVoltage::StaticPage

  layout "marketing"
end
