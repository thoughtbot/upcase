require "spec_helper"

describe WatchableRailsAdminField do
  context "#associated_collection" do
    it "sorts the delegated value" do
      unsorted = [2, 1, 3]
      type = double("type")
      field = double("field")
      allow(field).to receive(:associated_collection).with(type).
        and_return(unsorted)
      sorted_field = WatchableRailsAdminField.new(field)

      result = sorted_field.associated_collection(type)

      expect(result).to eq([1, 2, 3])
    end
  end

  context "#polymorphic_type_collection" do
    it "filters STI subclasses out" do
      types = [
        %w(Product Product),
        %w(Show Show),
        %w(Exercise Exercise)
      ]
      field = double("field", polymorphic_type_collection: types)
      sorted_field = WatchableRailsAdminField.new(field)

      result = sorted_field.polymorphic_type_collection

      expect(result).to eq([%w(Product Product), %w(Exercise Exercise)])
    end
  end

  context "#method_missing" do
    it "delegates to the decorated field" do
      value = double("value")
      field = double("field", partial: value)
      sorted_field = WatchableRailsAdminField.new(field)

      result = sorted_field.partial

      expect(result).to eq(value)
      expect(sorted_field).to be_kind_of(SimpleDelegator)
    end
  end
end
