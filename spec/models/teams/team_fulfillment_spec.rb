require "rails_helper"

module Teams
  describe TeamFulfillment do
    describe "#fulfill" do
      it "creates a new team with just that user" do
        user = create(
          :user,
          :with_subscription,
          email: "user.name@whatever.somethingcool.com"
        )
        checkout = build_stubbed(:checkout, quantity: 4)

        TeamFulfillment.new(checkout, user).fulfill

        team = user.reload.team
        expect(team).to be_present
        expect(team.name).to eq("Somethingcool")
        expect(team.subscription).to eq(user.subscription)
        expect(team.max_users).to eq(checkout.quantity)
      end
    end
  end
end
