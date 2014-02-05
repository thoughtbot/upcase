class EpisodesController < ApplicationController
  layout 'landing_pages'

  def show
    @video = Video.find(params[:id])
    @plan = IndividualPlan.basic

    if purchase = current_user_purchase_of(@video.watchable)
      redirect_to [purchase, @video]
    end
  end
end
