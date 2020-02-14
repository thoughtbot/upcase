require "rails_helper"

describe SlugConstraint do
  around do |example|
    Current.reset
    example.run
    Current.reset
  end

  describe "#matches?" do
    context "when request has an id that matches a product slug" do
      it "returns true" do
        product = create(:show)
        request = stub_request_with_id(product.slug)

        expect(SlugConstraint.new(Show).matches?(request)).to be true
      end
    end

    context "when request has an id that doesn't match right model" do
      it "returns false" do
        product = create(:repository)
        request = stub_request_with_id(product.slug)

        expect(
          SlugConstraint.new(Show).matches?(request)
        ).to be false
      end
    end

    context "when request has an id that doesn't match a slug" do
      it "returns false" do
        request = stub_request_with_id("test")

        expect(SlugConstraint.new(Show).matches?(request)).to be false
      end
    end

    def stub_request_with_id(id)
      double("request", path_parameters: { id: id })
    end
  end
end
