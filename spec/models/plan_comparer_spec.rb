require "spec_helper"

describe PlanComparer, type: :model do
  describe "#features_gained" do
    it "returns features the new plan has and the old plan doesn't have" do
      old_plan = build_stubbed(:plan, :no_mentor)
      new_plan = build_stubbed(:plan, :includes_mentor)
      comparer = PlanComparer.new(old_plan: old_plan, new_plan: new_plan)
      expect(comparer.features_gained).to eq(['mentor'])
    end

    it "returns an empty array when no features are gained" do
      old_plan = build_stubbed(:plan, :no_mentor)
      new_plan = build_stubbed(:plan, :no_mentor)
      comparer = PlanComparer.new(old_plan: old_plan, new_plan: new_plan)
      expect(comparer.features_gained).to eq([])
    end
  end

  describe "#features_lost" do
    it "returns features that the old plan has and the new plan doesn't have" do
      old_plan = build_stubbed(:plan, :includes_mentor)
      new_plan = build_stubbed(:plan, :no_mentor)
      comparer = PlanComparer.new(old_plan: old_plan, new_plan: new_plan)
      expect(comparer.features_lost).to eq(["mentor"])
    end

    it "returns an empty array when no features are lost" do
      old_plan = build_stubbed(:plan, :includes_mentor)
      new_plan = build_stubbed(:plan, :includes_mentor)
      comparer = PlanComparer.new(old_plan: old_plan, new_plan: new_plan)
      expect(comparer.features_lost).to eq([])
    end
  end
end
