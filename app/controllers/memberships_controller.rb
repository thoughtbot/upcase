class MembershipsController < ApplicationController
  before_action :must_be_team_owner
  before_action :stop_self_removal, if: :removing_self?

  def destroy
    current_team.remove_user(requested_team_user)
    flash[:alert] = "#{requested_team_user.name} has been removed."
    redirect_to edit_team_path
  end

  private

  def requested_team_user
    @_requested_team_user ||= current_team.users.find(params[:id])
  end

  def stop_self_removal
    flash[:alert] = "You cannot remove yourself from the team."
    redirect_to edit_team_path
  end

  def removing_self?
    requested_team_user == current_user
  end
end
