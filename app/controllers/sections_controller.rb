class SectionsController < ApplicationController
  def index
    @sections = Section.all
  end

  def show
    @section = Section.find(params[:id])

    render 'resources' if current_user.try(:registered_for?, @section)
  end
end
