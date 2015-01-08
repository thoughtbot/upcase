require "rails_helper"

describe SlugConstraint do
  describe "#matches?" do
    context "when request has an id that matches a product slug" do
      it "returns true" do
        product = create(:product)
        request = stub_request_with_id(product.slug)

        expect(SlugConstraint.new(Product).matches?(request)).to be true
      end
    end

    context "when request has an id that doesn't match right model" do
      it "returns false" do
        product = create(:product)
        request = stub_request_with_id(product.slug)

        expect(
          SlugConstraint.new(Show).matches?(request)
        ).to be false
      end
    end

    context "when request has an id that doesn't match a slug" do
      it "returns false" do
        request = stub_request_with_id("test")

        expect(SlugConstraint.new(Product).matches?(request)).to be false
      end
    end

    context "when request has an id that matches a video_tutorial slug" do
      it "returns true" do
        video_tutorial = create(:video_tutorial)
        request = stub_request_with_id(video_tutorial.slug)

        expect(
          SlugConstraint.new(VideoTutorial).matches?(request)
        ).to be true
      end
    end

    context "when request has an id not matching a video_tutorial slug" do
      it "returns false" do
        request = stub_request_with_id("test")

        expect(
          SlugConstraint.new(VideoTutorial).matches?(request)
        ).to be false
      end
    end

    def stub_request_with_id(id)
      stub("request", path_parameters: { id: id })
    end
  end
end
