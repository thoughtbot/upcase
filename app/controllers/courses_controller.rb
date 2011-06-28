class CoursesController < ApplicationController
  def index
    @courses = Course.by_position
  end

  def show
    @course = Course.find(params[:id])
    redirect_to(@course.active_section) if @course.active?
    @follow_up = @course.follow_ups.build
  end
end
