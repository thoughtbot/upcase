require "rails_helper"

RSpec.describe Guest do
  describe "#admin?" do
    it "returns false" do
      guest = Guest.new

      expect(guest).not_to be_admin
    end
  end

  describe "#has_access_to?" do
    it "returns false" do
      guest = Guest.new

      expect(guest).not_to have_access_to("anything")
    end
  end

  describe "#team" do
    it "returns nil" do
      guest = Guest.new

      expect(guest.team).to be(nil)
    end
  end

  describe "#email" do
    it "returns nil" do
      guest = Guest.new

      expect(guest.email).to be(nil)
    end
  end

  describe "#statuses" do
    it "returns no statuses" do
      create(:status)
      guest = Guest.new

      expect(guest.statuses).to be_empty
    end
  end
end
