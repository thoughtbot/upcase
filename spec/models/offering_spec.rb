require "spec_helper"

describe Offering do
  context "#user_has_license?" do
    it "returns false if the given user has no license to the offering" do
      user = create(:user)
      offering = Offering.new(create(:product), user)

      expect(offering.user_has_license?).to be_false
    end

    it "returns false if there is no user given" do
      offering = Offering.new(build_stubbed(:product), nil)

      expect(offering.user_has_license?).to be_false
    end

    it "returns true if the given user has a license to the offering" do
      user = create(:user)
      product = create(:product)
      create(:license, user: user, licenseable: product)

      offering = Offering.new(product, user)

      expect(offering.user_has_license?).to be_true
    end
  end
end
