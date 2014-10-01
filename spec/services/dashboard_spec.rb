require "rails_helper"

describe Dashboard do
  describe "#trails" do
    it "returns all trails" do
      dashboard = Dashboard.new

      expect(dashboard.trails).to find_relation(Trail.most_recent)
    end
  end
end
