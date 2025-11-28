require "rails_helper"

RSpec.describe ReturnPathFinder do
  describe "#return_path" do
    it "returns the return path specified in the URL" do
      url = "http://www.example.com?return_to=/some_url"
      finder = ReturnPathFinder.new(url)

      expect(finder.return_path).to eq "/some_url"
    end

    it "returns nil if there is no return path in the URL" do
      url = "http://www.example.com"
      finder = ReturnPathFinder.new(url)

      expect(finder.return_path).to be_nil
    end
  end
end
