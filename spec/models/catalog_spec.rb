require "rails_helper"

describe Catalog do
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
        to find_relation(VideoTutorial.active)
    end
  end

  describe "#mentors" do
    it "returns all mentors" do
      catalog = Catalog.new
      expect(catalog.mentors).to find_relation(Mentor.all)
    end
  end

  describe "#plans" do
    it "returns all featured active plans" do
      catalog = Catalog.new
      expect(catalog.individual_plans).
        to find_relation(Plan.individual.featured.active.ordered)
    end
  end

  describe "#repositories" do
    it "returns all active repositories in order" do
      catalog = Catalog.new
      expect(catalog.repositories).
        to find_relation(Repository.active.ordered)
    end
  end

  describe "#team_plan" do
    it "returns the first team featured active plans" do
      team_plan = stub(:plan)
      Plan.stubs(default_team: team_plan)
      catalog = Catalog.new

      expect(catalog.team_plan).to eq team_plan
      expect(Plan).to have_received(:default_team)
    end
  end

  describe "#to_partial_path" do
    it "returns a renderable path" do
      catalog = Catalog.new
      expect(catalog.to_partial_path).to eq("catalogs/catalog")
    end
  end
end
