class FollowUpsController < ApplicationController
  def create
    workshop = Workshop.find(params[:workshop_id])
    follow_up = workshop.follow_ups.build(workshop_params)
    if follow_up.save
      redirect_to workshop, notice: "We will contact you when we schedule #{workshop.name}."
    else
      redirect_to workshop, notice: "Could not save follow up. Please check your email address."
    end
  end

  private

  def workshop_params
    params.require(:follow_up).permit(:email)
  end
end
