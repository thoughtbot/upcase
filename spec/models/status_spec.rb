require 'rails_helper'

describe Status do
  it { should belong_to(:completeable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:completeable_type) }
  it { should validate_presence_of(:completeable_id) }
  it { should validate_presence_of(:user_id) }
  it { should ensure_inclusion_of(:state).in_array(Status::STATES) }

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

      expect(status.state).to eq "In Progress"
    end
  end
end
