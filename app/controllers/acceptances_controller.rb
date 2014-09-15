class AcceptancesController < ApplicationController
  def new
    @existing_user = User.exists?(email: find_invitation.email)
    @acceptance = build_acceptance
  end

  def create
    @acceptance = build_acceptance(acceptance_attributes)
    if @acceptance.save
      sign_in @acceptance.user
      redirect_to dashboard_url
    else
      render :new
    end
  end

  private

  def build_acceptance(attributes = {})
    Acceptance.new(find_invitation, attributes)
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
