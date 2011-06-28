class SectionsController < ApplicationController
  def show
    @section   = Section.find(params[:id])
    @follow_up = @section.course.follow_ups.build
  end
end
