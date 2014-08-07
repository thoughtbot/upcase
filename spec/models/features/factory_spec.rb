require "rails_helper"

describe Features::Factory, type: :model do
  describe "#new" do
    it "returns a specific instance for features with custom fulfillment" do
      factory = Features::Factory.new(user: build_stubbed(:user))
      expect(factory.new(:mentor)).to be_kind_of(Features::Mentor)
    end

    it "returns a generic instance for features without custom fulfillment" do
      factory = Features::Factory.new(user: build_stubbed(:user))
      expect(factory.new(:books)).to be_kind_of(Features::Generic)
    end

    it "works with string input" do
      factory = Features::Factory.new(user: build_stubbed(:user))
      expect(factory.new("mentor")).to be_kind_of(Features::Mentor)
    end
  end
end
