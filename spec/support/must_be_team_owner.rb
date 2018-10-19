shared_examples_for "must be team owner" do
  it "allows a user with a team" do
    user = create(:user, :with_attached_team)
    sign_in_as user

    perform_request

    should authorize
  end

  it "redirects a user who is not owner" do
    team = build_stubbed(:team)
    user = build_stubbed(:user, team: team)
    sign_in_as user

    perform_request

    should deny_access(
      flash: "You must be the owner of the team."
    )
  end

  it "redirects a user without a team" do
    user = build_stubbed(:user, team: nil)
    sign_in_as user

    perform_request

    should deny_access(
      flash: "You must be the owner of the team."
    )
  end

  it "redirects a guest" do
    perform_request

    should deny_access
  end

  def authorize
    respond_with(:success)
  end
end
