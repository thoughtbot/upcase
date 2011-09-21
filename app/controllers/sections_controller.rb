class SectionsController < ApplicationController
  def show
    @section   = Section.in_public_course.find(params[:id])
    @follow_up = @section.course.follow_ups.build
  end
end
