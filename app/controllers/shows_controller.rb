class ShowsController < ApplicationController
  layout "landing_pages"

  def show
    @offering = Offering.new(requested_show, current_user)
    @plan = Plan.basic

    respond_to do |format|
      format.html do
        if @offering.user_has_license?
          render polymorphic_licenseable_template, layout: "application"
        end
      end
      format.rss
    end
  end

  private

  def requested_show
    Show.friendly.find(params[:id])
  end
end
