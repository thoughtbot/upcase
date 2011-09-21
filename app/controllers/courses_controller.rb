class CoursesController < ApplicationController
  def index
    @audiences = Audience.by_position
  end

  def show
    @course = Course.only_public.find(params[:id])
    if @course.active?
      flash.keep
      redirect_to(@course.active_section)
    else
      @follow_up = @course.follow_ups.build
      km.record('Viewed Inactive Course', { 'Course Name' => @course.name })
    end
  end
end
