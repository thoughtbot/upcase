require "rails_helper"

describe NullShow do
  describe "#latest_video" do
    it "it returns nil" do
      result = NullShow.new.latest_video

      expect(result).to be_nil
    end
  end
end
