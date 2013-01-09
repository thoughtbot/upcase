class FollowUpsController < ApplicationController
  def create
    workshop = Workshop.find(params[:workshop_id])
    follow_up = workshop.follow_ups.build(params[:follow_up])
    if follow_up.save
      redirect_to root_path, notice: "We will contact you when we schedule #{workshop.name}."
      km.record('Requested Followup', { 'Course Name' => workshop.name })
    else
      redirect_to workshop, notice: "Could not save follow up. Please check your email address."
    end
  end
end
