class AcceptancesController < ApplicationController
  def new
    @acceptance = build_acceptance
  end

  def create
    @acceptance = build_acceptance(acceptance_attributes)
    if @acceptance.save
      sign_in @acceptance.user
      redirect_to(
        practice_url,
        notice: "You've been added to the team. Enjoy!"
      )
    else
      render :new
    end
  end

  private

  def build_acceptance(attributes = {})
    Acceptance.new(
      invitation: find_invitation,
      current_user: current_user,
      attributes: attributes
    )
  end

  def find_invitation
    Invitation.find(params[:invitation_id])
  end

  def acceptance_attributes
    params.
      require(:acceptance).
      permit(:github_username, :name, :password)
  end
end
