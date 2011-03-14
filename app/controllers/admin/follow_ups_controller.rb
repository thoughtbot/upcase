class Admin::FollowUpsController < AdminController
  def create
    course = Course.find(params[:course_id])
    follow_up = course.follow_ups.build(params[:follow_up])
    if follow_up.save
      flash[:notice] = "Follow up saved"
    else
      flash[:notice] = "Could not save follow up."
    end
    redirect_to [admin, course]
  end

  def destroy
    course = Course.find(params[:course_id])
    follow_up = course.follow_ups.find(params[:id])
    follow_up.destroy
    flash[:notice] = "Follow up removed"
    redirect_to edit_admin_course_path(course)
  end
end
