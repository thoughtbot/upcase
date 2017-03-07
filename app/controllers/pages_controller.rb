class PagesController < HighVoltage::PagesController
  include HighVoltage::StaticPage

  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when "welcome-b"
      "marketing"
    end
  end
end
