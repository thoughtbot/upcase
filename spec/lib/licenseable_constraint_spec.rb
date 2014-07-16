require "spec_helper"

describe LicenseableConstraint do
  describe "#matches?" do
    context "when request has an id that matches a product slug" do
      it "returns true" do
        product = create(:product)
        request = stub_request_with_id(product.slug)

        expect(LicenseableConstraint.new(Product).matches?(request)).to be true
      end
    end

    context "when request has an id that doesn't match right model" do
      it "returns false" do
        product = create(:product)
        request = stub_request_with_id(product.slug)

        expect(
          LicenseableConstraint.new(Screencast).matches?(request)
        ).to be false
      end
    end

    context "when request has an id that doesn't match a slug" do
      it "returns false" do
        request = stub_request_with_id("test")

        expect(LicenseableConstraint.new(Product).matches?(request)).to be false
      end
    end

    context "when request has an id that matches a workshop slug" do
      it "returns true" do
        workshop = create(:workshop)
        request = stub_request_with_id(workshop.slug)

        expect(LicenseableConstraint.new(Workshop).matches?(request)).to be true
      end
    end

    context "when request has an id not matching a workshop slug" do
      it "returns false" do
        request = stub_request_with_id("test")

        expect(
          LicenseableConstraint.new(Workshop).matches?(request)
        ).to be false
      end
    end

    def stub_request_with_id(id)
      stub("request", path_parameters: { id: id })
    end
  end
end
