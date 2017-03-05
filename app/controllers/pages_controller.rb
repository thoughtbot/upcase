class PagesController < HighVoltage::PagesController
  include HighVoltage::StaticPage

  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when "tapas-for-teams"
      "splash"
    when "tapas-for-one"
      "splash"
    when "welcome-b"
      "splash"
    end
  end
end
