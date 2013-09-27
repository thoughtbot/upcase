class WorkshopsController < ApplicationController
  def index
    respond_to do |format|
      format.html { redirect_to products_path }
      format.json do
        @workshops = Workshop.only_active.by_position
      end
    end
  end

  def show
    @workshop = Workshop.find(params[:id])
    @offering = @workshop
    @sections = @workshop.active_sections
    @section_teachers = @sections.unique_section_teachers_by_teacher

    if signed_in? && @workshop.purchase_for(current_user)
      redirect_to @workshop.purchase_for(current_user)
    else
      km.record("Viewed Product", { "Product Name" => @workshop.name })
    end
  end
end
