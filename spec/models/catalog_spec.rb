require "rails_helper"

RSpec.describe Catalog do
  describe "#products" do
    it "returns active products in order" do
      catalog = Catalog.new
      expect(catalog.products).to find_relation(Product.active.ordered)
    end
  end

  describe "#videos" do
    it "returns published videos in order" do
      catalog = Catalog.new
      expect(catalog.videos)
        .to find_relation(Video.published.recently_published_first)
    end
  end

  describe "#repositories" do
    it "returns all top-level, active repositories in order" do
      catalog = Catalog.new
      expect(catalog.repositories)
        .to find_relation(Repository.active.top_level.ordered)
    end
  end

  describe "#to_partial_path" do
    it "returns a renderable path" do
      catalog = Catalog.new
      expect(catalog.to_partial_path).to eq("catalogs/catalog")
    end
  end
end
