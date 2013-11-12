class WorkshopsController < ApplicationController
  def show
    @workshop = Workshop.find(params[:id])
    @offering = @workshop
    @sections = @workshop.active_sections
    @section_teachers = @sections.unique_section_teachers_by_teacher

    if signed_in? && @workshop.purchase_for(current_user)
      redirect_to @workshop.purchase_for(current_user)
    end
  end
end
