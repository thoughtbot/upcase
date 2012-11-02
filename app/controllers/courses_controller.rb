class CoursesController < ApplicationController
  def index
    @audiences = Audience.by_position
  end

  def show
    @course = Course.find(params[:id])
    @sections = @course.sections.active
    @section_teachers = @sections.map(&:section_teachers).flatten
  end
end
