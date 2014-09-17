require "rails_helper"

describe PromotedCatalog do
  describe "any method" do
    it "delegates to catalog and calls promoted on the returned object" do
      video_tutorial_relation = stub("video_tutorial_relation",
                                     promoted: :some_video_tutorials)
      catalog = stub("catalog", video_tutorials: video_tutorial_relation)
      promoted_catalog = PromotedCatalog.new(catalog)

      expect(promoted_catalog.video_tutorials).to eq(:some_video_tutorials)
      expect(video_tutorial_relation).to have_received(:promoted)
    end
  end
end
