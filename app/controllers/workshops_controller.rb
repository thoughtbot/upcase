class WorkshopsController < ApplicationController
  def show
    @workshop = Workshop.find(params[:id])
    @offering = @workshop

    if purchase = current_user_purchase_of(@workshop)
      redirect_to purchase
    end
  end
end
