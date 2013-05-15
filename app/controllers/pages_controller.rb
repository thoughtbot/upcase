class PagesController < HighVoltage::PagesController
  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'prime'
      'prime'
    else
      'application'
    end
  end
end
