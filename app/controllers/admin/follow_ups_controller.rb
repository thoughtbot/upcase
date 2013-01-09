class Admin::FollowUpsController < AdminController
  def create
    workshop = Workshop.find(params[:workshop_id])
    follow_up = workshop.follow_ups.build(params[:follow_up])
    if follow_up.save
      flash[:notice] = "Follow up saved"
    else
      flash[:notice] = "Could not save follow up."
    end
    redirect_to [admin, workshop]
  end

  def destroy
    workshop = Workshop.find(params[:workshop_id])
    follow_up = workshop.follow_ups.find(params[:id])
    follow_up.destroy
    flash[:notice] = "Follow up removed"
    redirect_to edit_admin_workshop_path(workshop)
  end
end
