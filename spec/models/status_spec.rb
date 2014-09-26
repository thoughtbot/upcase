require 'rails_helper'

describe Status do
  it { should belong_to(:exercise) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:exercise_id) }
  it { should validate_presence_of(:user_id) }
  it { should ensure_inclusion_of(:state).in_array(Status::STATES) }

  context "uniqueness" do
    subject do
      create(:status)
    end

    it { should validate_uniqueness_of(:user_id).scoped_to(:exercise_id) }
  end

  context "#state" do
    it "has a default state of Started" do
      status = Status.new

      expect(status.state).to eq "Started"
    end
  end
end
