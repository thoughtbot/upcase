class SectionsController < ApplicationController
  before_filter :dashboard_if_admin

  def index
    @sections = Section.all
  end

  def show
    @section = Section.find(params[:id])

    render 'resources' if current_user.try(:registered_for?, @section)
  end

  protected

  def dashboard_if_admin
    redirect_to courses_url if current_user.try(:admin?)
  end
end
