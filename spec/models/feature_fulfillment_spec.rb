require "spec_helper"

describe FeatureFulfillment, :type => :model do
  describe "#fulfill_gained_features" do
    it "calls #fulfill on each gained feature" do
      old_plan = build_stubbed(:plan, :no_mentor)
      new_plan = build_stubbed(:plan, :includes_mentor)
      mentor_feature = stub_mentor_feature

      FeatureFulfillment.new(
        new_plan: new_plan,
        old_plan: old_plan,
        user: build_stubbed(:user)
      ).fulfill_gained_features

      expect(mentor_feature).to have_received(:fulfill)
    end
  end

  describe "#unfulfill_lost_features" do
    it "calls #unfulfill on each lost feature" do
      old_plan = create(:plan, :includes_mentor)
      new_plan = create(:plan, :no_mentor)
      mentor_feature = stub_mentor_feature

      FeatureFulfillment.new(
        new_plan: new_plan,
        old_plan: old_plan,
        user: build_stubbed(:user)
      ).unfulfill_lost_features

      expect(mentor_feature).to have_received(:unfulfill)
    end
  end

  def stub_mentor_feature
    stub(fulfill: nil, unfulfill: nil).tap do |mentor_feature|
      Features::Mentor.stubs(:new).returns(mentor_feature)
    end
  end
end
