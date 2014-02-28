class PagesController < HighVoltage::PagesController
  layout :layout_for_page

  def show
    render :template => current_page
  end

  private

  def layout_for_page
    if params[:id] == 'new-product'
      'header-only'
    else
      'application'
    end
  end
end
