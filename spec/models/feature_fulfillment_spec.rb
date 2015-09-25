require "rails_helper"

describe FeatureFulfillment do
  describe "#fulfill_gained_features" do
    it "calls #fulfill on each gained feature" do
      old_plan = build_stubbed(:plan, :no_repositories)
      new_plan = build_stubbed(:plan, :includes_repositories)
      repository_feature = stub_repository_feature

      FeatureFulfillment.new(
        new_plan: new_plan,
        old_plan: old_plan,
        user: build_stubbed(:user)
      ).fulfill_gained_features

      expect(repository_feature).to have_received(:fulfill)
    end
  end

  describe "#unfulfill_lost_features" do
    it "calls #unfulfill on each lost feature" do
      old_plan = create(:plan, :includes_repositories)
      new_plan = create(:plan, :no_repositories)
      repository_feature = stub_repository_feature

      FeatureFulfillment.new(
        new_plan: new_plan,
        old_plan: old_plan,
        user: build_stubbed(:user)
      ).unfulfill_lost_features

      expect(repository_feature).to have_received(:unfulfill)
    end
  end

  def stub_repository_feature
    double(fulfill: nil, unfulfill: nil).tap do |repository_feature|
      allow(Features::Repository).to(
        receive(:new).and_return(repository_feature),
      )
    end
  end
end
