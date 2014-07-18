class WorkshopsController < ApplicationController
  def show
    @workshop = Workshop.find(params[:id])
    @offering = @workshop

    if @license = current_user_license_of(@offering)
      render polymorphic_licenseable_template
    end
  end
end
