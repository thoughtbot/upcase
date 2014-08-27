class TeamFulfillment
  def initialize(checkout, user)
    @checkout = checkout
    @user = user
  end

  def fulfill
    @user.team = create_team
    @user.save!
  end

  private

  def create_team
    Team.create!(
      name: generate_team_name,
      subscription: subscription
    )
  end

  def generate_team_name
    @user.email.sub(/^.*@/, "").split(".")[-2].titleize
  end

  def subscription
    @user.subscription
  end
end
