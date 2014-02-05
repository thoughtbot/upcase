class WorkshopsController < ApplicationController
  def show
    @workshop = Workshop.find(params[:id])
    @offering = @workshop

    if signed_in? && @workshop.purchase_for(current_user)
      redirect_to @workshop.purchase_for(current_user)
    end
  end
end
