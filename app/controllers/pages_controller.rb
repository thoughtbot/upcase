class PagesController < HighVoltage::PagesController
  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'prime'
      'empty-body'
    when 'learnsale'
      'empty-body'
    when 'new-product'
      'header-only'
    else
      'application'
    end
  end
end
