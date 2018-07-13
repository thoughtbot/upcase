require "rails_helper"

describe RailsAdminHelper do
  describe "#month_filter" do
    it "converts a month to form data" do
      date = Date.current
      result = helper.month_filter(date)

      expect(result).to include(:created_at)
    end
  end
end
