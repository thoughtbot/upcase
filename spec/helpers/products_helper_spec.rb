require "rails_helper"

RSpec.describe ProductsHelper do
  describe "#test_driven_rails_url" do
    it "returns a link to the right page" do
      result = helper.test_driven_rails_url

      expect(result).to include("test-driven-rails")
    end
  end

  describe "#design_for_developers_url" do
    it "returns a link to the right page" do
      result = helper.design_for_developers_url

      expect(result).to include("design-for-developers")
    end
  end
end
