class SectionsController < ApplicationController
  # def index
  #   @sections            = Section.active.by_starts_on
  #   @unscheduled_courses = Course.unscheduled
  # end

  def show
    @section   = Section.find(params[:id])
    @follow_up = @section.course.follow_ups.build
  end
end
