require "rails_helper"

describe Reactivation do
  context "#fulfill" do
    it "returns false if we cnanot fulfill in the first place" do
      subscription = double(scheduled_for_deactivation?: false)
      reactivation = Reactivation.new(subscription: subscription)

      expect(reactivation.fulfill).to be false
    end

    it "tries to reactivate on the subscription if it can fulfill" do
      subscription = spy(
        scheduled_for_deactivation?: true,
        reactivate: true
      )
      reactivation = Reactivation.new(subscription: subscription)

      expect(reactivation.fulfill).to be true
      expect(subscription).to have_received(:reactivate)
    end
  end
end
