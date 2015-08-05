class PagesController < HighVoltage::PagesController
  layout :layout_for_page

  private

  def layout_for_page
    if params[:id] == "new-product"
      "header-only"
    elsif params[:id] == "landing"
      "landing_pages"
    else
      "application"
    end
  end
end
