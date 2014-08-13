class InvitationsController < ApplicationController
  before_filter :must_be_team_member

  def index
    @team = current_user.team
  end

  def create
    if deliver_invitation
      redirect_with_notice
    else
      render_errors
    end
  end

  private

  def deliver_invitation
    @invitation = Invitation.new(invitation_attributes)
    @invitation.deliver
  end

  def redirect_with_notice
    redirect_to edit_team_path, notice: 'Invitation sent.'
  end

  def render_errors
    render :new
  end

  def invitation_attributes
    params.
      require(:invitation).
      permit(:email).
      merge(sender: current_user, team: current_user.team)
  end
end
