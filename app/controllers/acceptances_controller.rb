class AcceptancesController < ApplicationController
  before_filter :must_have_users_remaining

  def new
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

  def must_have_users_remaining
    unless find_invitation.has_users_remaining?
      deny_access "There are no users remaining for that team."
    end
  end
end
