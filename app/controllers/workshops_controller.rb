class WorkshopsController < ApplicationController
  def index
    @workshops = Workshop.only_active.by_position
  end

  def show
    @workshop = Workshop.find(params[:id])
    @offering = @workshop
    @sections = @workshop.active_sections
    @section_teachers = @sections.unique_section_teachers_by_teacher
    @viewable_subscription =
      ViewableSubscription.new(current_user, subscription_product)

    if signed_in? && @workshop.purchase_for(current_user)
      redirect_to @workshop.purchase_for(current_user)
    else
      km.record("Viewed Product", { "Product Name" => @workshop.name })
    end
  end
end
