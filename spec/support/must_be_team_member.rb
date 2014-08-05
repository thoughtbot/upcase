shared_examples_for "must be team member" do
  it 'allows a user with a team' do
    team = build_stubbed(:team)
    user = build_stubbed(:user, team: team)
    sign_in_as user

    perform_request

    should authorize
  end

  it 'redirects a user without a team' do
    user = build_stubbed(:user, team: nil)
    sign_in_as user

    perform_request

    should deny_access(
      flash: 'You must be a member of a team to access that resource.'
    )
  end

  it 'redirects a guest' do
    sign_out

    perform_request

    should deny_access
  end

  def authorize
    respond_with(:success)
  end
end
