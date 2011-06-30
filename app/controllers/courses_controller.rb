class CoursesController < ApplicationController
  respond_to :html, :json, :only => [:index]
  def index
    respond_with(@courses = Course.by_position)
  end

  def show
    @course = Course.find(params[:id])
    if @course.active?
      redirect_to(@course.active_section)
    else
      @follow_up = @course.follow_ups.build
    end
  end
end
