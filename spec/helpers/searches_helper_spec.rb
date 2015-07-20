require "rails_helper"

describe SearchesHelper do
  describe "#cleaned_search_excerpt" do
    it "removes repeated dashes and pipe characters from provided string" do
      highlight_string = "title ===== ``` hello ``` ----- world ||||| things"

      result = helper.cleaned_search_excerpt(highlight_string)

      expect(result).to eq("title = ` hello ` - world | things")
    end
  end
end
