require "rails_helper"

RSpec.describe MembershipsController do
  it "does not allow you to remove yourself" do
    user = create(:user, :with_attached_team)
    sign_in_as user

    delete :destroy, params: {id: user}

    expect(response).to redirect_to edit_team_path
    expect(flash[:alert]).to include "cannot remove yourself"
    expect(user.reload).to be_persisted
  end

  it "allows a user with a team" do
    user = create(:user, :with_attached_team)
    sign_in_as user

    remove_other_user_from_team

    expect(response).to redirect_to edit_team_path
    expect(flash[:alert]).to include "has been removed"
  end

  it "redirects a user who is not owner" do
    team = create(:team)
    _owner = create(:user, team: team)
    user = create(:user, team: team)
    sign_in_as user

    remove_other_user_from_team

    should deny_access(
      flash: "You must be the owner of the team."
    )
  end

  it "redirects a user without a team" do
    user = build_stubbed(:user, team: nil)
    sign_in_as user

    remove_other_user_from_team

    should deny_access(
      flash: "You must be the owner of the team."
    )
  end

  it "redirects a guest" do
    remove_other_user_from_team

    should deny_access
  end

  def remove_other_user_from_team
    user_to_remove = create(:user, :with_github)
    if @controller.current_user&.team
      @controller.current_user.team.add_user(user_to_remove)
    end

    delete :destroy, params: {id: user_to_remove}
  end
end
