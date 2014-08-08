class ShowsController < ApplicationController
  layout "landing_pages"

  def show
    @offering = Offering.new(requested_show, current_user)
    @plan = IndividualPlan.basic

    if @offering.user_has_license?
      render polymorphic_licenseable_template, layout: "application"
    end
  end

  private

  def requested_show
    Show.find(params[:id])
  end
end
