class FollowUpsController < ApplicationController
  def create
    course = Course.find(params[:course_id])
    follow_up = course.follow_ups.build(params[:follow_up])
    if follow_up.save
      redirect_to root_path, notice: "We will contact you when we schedule #{course.name}."
      km.record('Requested Followup', { 'Course Name' => course.name })
    else
      redirect_to course, notice: "Could not save follow up. Please check your email address."
    end
  end
end
