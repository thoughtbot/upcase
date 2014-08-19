shared_examples_for "must be subscription owner" do
  it "allows a user who owns the subscription " do
    user = create(:subscriber)
    sign_in_as user

    perform_request

    should authorize
  end

  it "allows a user who owns the team subscription " do
    user = create(:user, :with_team_subscription)
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
      flash: "You must be the owner of the subscription."
    )
  end

  it "redirects a user without a subscription" do
    user = build_stubbed(:user, team: nil)
    sign_in_as user

    perform_request

    should deny_access(
      flash: "You must be the owner of the subscription."
    )
  end

  it "redirects a guest" do
    sign_out

    perform_request

    should deny_access
  end

  def authorize
    respond_with(:success)
  end
end
