class SectionsController < ApplicationController
  def show
    section = Section.find(params[:id])
    redirect_to section.workshop
  end
end
