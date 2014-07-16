class WorkshopsController < ApplicationController
  def show
    @offering = Offering.new(workshop, current_user)

    if @offering.user_has_license?
      render polymorphic_licenseable_template
    end
  end

  private

  def workshop
    Workshop.friendly.find(params[:id])
  end
end
