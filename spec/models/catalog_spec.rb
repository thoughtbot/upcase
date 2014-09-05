require "rails_helper"

describe Catalog do
  describe "#books" do
    it "returns active books in order" do
      catalog = Catalog.new
      expect(catalog.books).to find_relation(Book.active.ordered)
    end
  end

  describe "#products" do
    it "returns active products in order" do
      catalog = Catalog.new
      expect(catalog.products).to find_relation(Product.active.ordered)
    end
  end

  describe "#videos" do
    it "returns published videos in order" do
      catalog = Catalog.new
      expect(catalog.videos).
        to find_relation(Video.published.recently_published_first)
    end
  end

  describe "#video_tutorials" do
    it "returns active video_tutorials in order" do
      catalog = Catalog.new
      expect(catalog.video_tutorials).
        to find_relation(VideoTutorial.only_active.by_position)
    end
  end

  describe "#screencasts" do
    it "returns active screencasts with the most recent first" do
      catalog = Catalog.new
      expect(catalog.screencasts).
        to find_relation(Screencast.active.newest_first)
    end
  end

  describe "#shows" do
    it "returns active shows by name" do
      catalog = Catalog.new
      expect(catalog.shows).to find_relation(Show.active.ordered)
    end
  end

  describe "#exercises" do
    it "returns exercises by position" do
      catalog = Catalog.new
      expect(catalog.exercises).to find_relation(Exercise.ordered)
    end
  end

  describe "#mentors" do
    it "returns all mentors" do
      catalog = Catalog.new
      expect(catalog.mentors).to find_relation(Mentor.all)
    end
  end

  describe "#individual_plans" do
    it "returns all featured active plans" do
      catalog = Catalog.new
      expect(catalog.individual_plans).
        to find_relation(IndividualPlan.featured.active.ordered)
    end
  end

  describe "#to_partial_path" do
    it "returns a renderable path" do
      catalog = Catalog.new
      expect(catalog.to_partial_path).to eq("catalogs/catalog")
    end
  end
end
