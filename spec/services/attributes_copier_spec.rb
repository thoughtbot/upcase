require "spec_helper"

describe AttributesCopier do
  describe "#copy" do
    it "copies attributes present in source to target" do
      target = OpenStruct.new(a: 1,   b: 2)
      source = OpenStruct.new(a: nil, b: 3, c: 4, d: 5)

      AttributesCopier.new(
        target: target,
        source: source,
        attributes: %i(a b c)
      ).copy_present_attributes

      expect(target).to eq(OpenStruct.new(a: 1, b: 3, c: 4))
    end
  end
end
