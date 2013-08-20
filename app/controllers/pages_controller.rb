class PagesController < HighVoltage::PagesController
  layout :layout_for_page

  def show
    @mentor_1 = User.mentors.first
    @mentor_2 = User.mentors.second
    render :template => current_page
  end

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
