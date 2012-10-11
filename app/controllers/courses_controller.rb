class CoursesController < ApplicationController
  def index
    @audiences = Audience.by_position
  end

  def show
    @course = Course.find(params[:id])
    @sections = @course.sections.active
  end
end
