require "rails_helper"

describe TopicsHelper do
  describe "#resource_classes" do
    it "returns a string of resource types" do
      resource = { "type" => "test" }

      result = helper.resource_classes(resource)

      expect(result).to eq "resource test"
    end
  end
end
