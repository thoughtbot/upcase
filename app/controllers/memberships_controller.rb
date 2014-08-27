class MembershipsController < ApplicationController
  before_filter :must_be_team_owner

  def destroy
    user = current_team.users.find(params[:id])
    if user == current_user
      flash[:notice] = "You cannot remove yourself from the team."
    else
      current_team.remove_user(user)
      flash[:notice] = "#{user.name} has been removed."
    end
    redirect_to edit_team_path
  end
end
