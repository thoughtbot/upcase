require "spec_helper"

describe Offering do
  context "#license" do
    it "returns the license for a user with one" do
      user = create(:user)
      product = create(:product)
      license = create(:license, user: user, licenseable: product)

      offering = Offering.new(product, user)

      expect(offering.license).to eq license
    end

    it "returns nil if there is no license for the user" do
      user = create(:user)
      offering = Offering.new(create(:product), user)

      expect(offering.license).to be_nil
    end

    it "returns nil if there is no user" do
      offering = Offering.new(build_stubbed(:product), nil)

      expect(offering.license).to be_nil
    end
  end
  context "#user_has_license?" do
    it "returns false if the given user has no license to the offering" do
      user = create(:user)
      offering = Offering.new(create(:product), user)

      expect(offering.user_has_license?).to be false
    end

    it "returns false if there is no user given" do
      offering = Offering.new(build_stubbed(:product), nil)

      expect(offering.user_has_license?).to be false
    end

    it "returns true if the given user has a license to the offering" do
      user = create(:user)
      product = create(:product)
      create(:license, user: user, licenseable: product)

      offering = Offering.new(product, user)

      expect(offering.user_has_license?).to be true
    end
  end

  it "delegates methods to the product when the licenseable" do
    product = stub(short_description: "Test Description")
    offering = Offering.new(product, nil)

    expect(offering.short_description).to eq "Test Description"
  end
end
