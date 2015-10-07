class PagesController < HighVoltage::PagesController
  layout :layout_by_signed_in_state
end
