require "rails_helper"

describe LandingPage do
  describe "#community_size" do
    it "returns the subscriber count" do
      allow(User).to receive(:subscriber_count).and_return(5)

      result = LandingPage.new.community_size

      expect(result).to eq 5
      expect(User).to have_received(:subscriber_count)
    end
  end

  describe "#topics" do
    it "returns the explorable topics" do
      topics = [build_stubbed(:topic)]
      allow(Topic).to receive(:explorable).and_return(topics)

      result = LandingPage.new.topics

      expect(result).to eq topics
      expect(Topic).to have_received(:explorable)
    end
  end

  describe "#example_trail" do
    it "returns the first explorable as TrailWithProgress" do
      trail = build_stubbed(:trail)
      allow(Trail).to receive(:most_recent_published).and_return([trail])
      trail_with_progress = double
      allow(TrailWithProgress).to receive(:new).and_return(trail_with_progress)

      result = LandingPage.new.example_trail

      expect(result).to eq trail_with_progress
      expect(TrailWithProgress).to have_received(:new).with(trail, user: nil)
    end
  end

  describe "#primary_plan" do
    it "returns the popular plan" do
      plan = build_stubbed(:plan)
      allow(Plan).to receive(:popular).and_return(plan)

      result = LandingPage.new.primary_plan

      expect(result).to eq plan
      expect(Plan).to have_received(:popular)
    end
  end

  describe "#secondary_plan" do
    it "returns the basic plan" do
      plan = build_stubbed(:plan)
      allow(Plan).to receive(:basic).and_return(plan)

      result = LandingPage.new.secondary_plan

      expect(result).to eq plan
      expect(Plan).to have_received(:basic)
    end
  end
end
