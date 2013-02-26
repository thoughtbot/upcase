class WorkshopsController < ApplicationController
  def index
    @workshops = Workshop.only_public.by_position
  end

  def show
    @workshop = Workshop.find(params[:id])
    @sections = @workshop.active_sections
    @section_teachers = @sections.unique_section_teachers_by_teacher

    km.record("Viewed Product", { "Product Name" => @workshop.name })
  end
end
