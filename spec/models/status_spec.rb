require "rails_helper"

describe Status do
  it { should belong_to(:completeable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:completeable_type) }
  it { should validate_presence_of(:completeable_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_inclusion_of(:state).in_array(Status::STATES) }

  context ".most_recent" do
    it "returns the latest status" do
      status = create(:status)
      Timecop.travel(1.day.ago) do
        create(:status)
      end

      expect(Status.most_recent).to eq status
    end
  end

  context "#state" do
    it "has a default state of In Progress" do
      status = Status.new

      expect(status.state).to eq Status::IN_PROGRESS
    end

    describe ".active" do
      it "start state is considered active" do
        status = create(:status)

        expect(Status.active).to include(status)
      end
    end
  end

  describe "#most_recent_for_user" do
    context "when the user has started the completeable" do
      it "returns the most recent status for the user" do
        user = create(:user)
        status = create(:status, user: user)

        result = Status.most_recent_for_user(user)

        expect(result).to eq(status)
      end
    end

    context "when the user has not started the completeable" do
      it "returns an Unstarted null object" do
        user = build_stubbed(:user)

        result = Status.most_recent_for_user(user)

        expect(result).to be_a Unstarted
      end
    end
  end
end
