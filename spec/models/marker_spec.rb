require "rails_helper"

describe Marker do
  it { should belong_to(:video) }
  it { should validate_presence_of(:anchor) }
  it { should validate_presence_of(:time) }

  describe "#to_json" do
    it "returns only the anchor and the time" do
      marker = build_stubbed(:marker)

      json_keys = JSON.parse(marker.to_json).keys

      expect(json_keys).to match(["anchor", "time"])
    end
  end
end
