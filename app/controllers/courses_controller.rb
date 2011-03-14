class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])
    @follow_up = @course.follow_ups.build
  end
end
