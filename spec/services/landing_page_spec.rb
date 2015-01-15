require "rails_helper"

describe LandingPage do
  describe "#community_size" do
    it "returns the subscriber count" do
      User.stubs(:subscriber_count).returns(5)

      result = LandingPage.new.community_size

      expect(result).to eq 5
      expect(User).to have_received(:subscriber_count)
    end
  end

  describe "#topics" do
    it "returns the explorable topics" do
      topics = [build_stubbed(:topic)]
      Topic.stubs(:explorable).returns(topics)

      result = LandingPage.new.topics

      expect(result).to eq topics
      expect(Topic).to have_received(:explorable)
    end
  end

  describe "#example_trail" do
    it "returns the first explorable as TrailWithProgress" do
      trail = build_stubbed(:trail)
      Trail.stubs(:most_recent_published).returns([trail])
      trail_with_progress = stub
      TrailWithProgress.stubs(:new).returns(trail_with_progress)

      result = LandingPage.new.example_trail

      expect(result).to eq trail_with_progress
      expect(TrailWithProgress).to have_received(:new).with(trail, user: nil)
    end
  end

  describe "#primary_plan" do
    it "returns the popular plan" do
      plan = build_stubbed(:plan)
      Plan.stubs(:popular).returns(plan)

      result = LandingPage.new.primary_plan

      expect(result).to eq plan
      expect(Plan).to have_received(:popular)
    end
  end

  describe "#secondary_plan" do
    it "returns the basic plan" do
      plan = build_stubbed(:plan)
      Plan.stubs(:basic).returns(plan)

      result = LandingPage.new.secondary_plan

      expect(result).to eq plan
      expect(Plan).to have_received(:basic)
    end
  end
end
