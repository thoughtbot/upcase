class PagesController < HighVoltage::PagesController
  layout :layout_for_page

  private

  def layout_for_page
    if params[:id] == "new-product"
      "header-only"
    elsif landing_page?
      "landing_pages"
    else
      "application"
    end
  end

  def landing_page?
    %w{ landing checkout }.include?(params[:id])
  end
end
