class CoursesController < ApplicationController
  def index
    @audiences = Audience.by_position
  end

  def show
    @course = Course.find(params[:id])
    @sections = @course.sections.active
    @section_teachers = @sections.unique_section_teachers_by_teacher
    km.record("Viewed Product", { "Product Name" => @course.name })
  end
end
