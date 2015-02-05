require "rails_helper"

describe StatusUpdater do
  describe "#update_state" do
    it "creates a status" do
      completeable = mock_completeable
      updater = StatusUpdater.new(completeable, user)
      allow(Status).to receive(:create!)

      updater.update_state("New state")

      expect(Status).to have_received(:create!).
        with(user: user, completeable: completeable, state: "New state")
    end

    it "updates the state for trails associated with the completeable" do
      completeable = mock_completeable(trails: [trail])
      updater = StatusUpdater.new(completeable, user)
      allow(Status).to receive(:create!)

      updater.update_state("New state")

      expect(trail).to have_received(:update_state_for)
    end

    def mock_completeable(trails: [])
      @completeable ||= double("completeable").tap do |completeable|
        allow(completeable).to receive(:trails).and_return(trails)
      end
    end

    def trail
      @trail ||= double("trail").tap do |trail|
        allow(trail).to receive(:update_state_for)
      end
    end

    def user
      @user ||= double("user")
    end
  end
end
