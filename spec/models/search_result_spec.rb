require "rails_helper"

describe SearchResult do
  describe "#to_partial_path" do
    it "returns a partial path based on the model type" do
      video = build_stubbed(:video)
      result = build_search_result(model: video)

      expect(result.to_partial_path).to eq("searches/video")
    end
  end

  describe "delegation" do
    it "should delegate methods to the model" do
      video = build_stubbed(:video, name: "tmux adventures")
      result = build_search_result(model: video)

      expect(result.name).to eq(video.name)
    end
  end

  def build_search_result(model:, excerpt: "sample excerpt")
    SearchResult.new(model, excerpt)
  end
end
