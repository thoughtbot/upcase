class FollowUpsController < ApplicationController
  def create
    course = Course.find(params[:course_id])
    follow_up = course.follow_ups.build(params[:follow_up])
    if follow_up.save
      flash[:notice] = "We will contact you when we schedule this course."
    else
      flash[:notice] = "Could not save follow up. Please check your email address."
    end
    redirect_to course
  end

  def destroy
    course = Course.find(params[:course_id])
    follow_up = course.follow_ups.find(params[:id])
    follow_up.destroy
    flash[:notice] = "Follow up removed"
    redirect_to edit_course_path(course)
  end
end
