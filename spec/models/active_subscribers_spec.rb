require "rails_helper"

describe ActiveSubscribers do
  it "finds personal plan subscribers" do
    user = create(:user, name: "personal")
    create(:subscription, user: user)

    expect(active_subscriber_names).to eq([user.name])
  end

  it "finds members of active teams" do
    team_leader = create(:user, name: "team leader")
    team_member = create(:user, name: "team member")
    sub = create(:team_subscription, user: team_leader)
    create(:team, subscription: sub, users: [team_leader, team_member])

    expect(active_subscriber_names).to match_array(
      [team_leader.name, team_member.name],
    )
  end

  it "ignores deactivated subscriptions" do
    user = create(:user, name: "inactive")
    create(:inactive_subscription, user: user)

    expect(active_subscriber_names).to eq([])
  end

  def active_subscriber_names
    ActiveSubscribers.new.map(&:name)
  end
end
