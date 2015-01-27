require "rails_helper"

describe Step do
  it { should belong_to(:completeable) }
  it { should belong_to(:trail) }
  it { should validate_presence_of(:completeable) }
  it { should validate_presence_of(:trail) }

  context "with an existing step" do
    before { create(:step) }
    it { should validate_uniqueness_of(:position).scoped_to(:trail_id) }
  end

  describe "#name" do
    it "returns the completeable type and name" do
      completeable = create(:exercise, name: "My Completeable Title")
      step = build(:step, completeable: completeable)

      expect(step.name).to eq "Exercise - My Completeable Title"
    end
  end
end
