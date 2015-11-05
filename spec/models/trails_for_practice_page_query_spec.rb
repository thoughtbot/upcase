require "rails_helper"

describe TrailsForPracticePageQuery do
  describe "#each" do
    it "yields only published trails" do
      create(:trail, :published, name: "published-trail")
      create(:trail, :unpublished, name: "unpublished-trail")

      result = run_query.map(&:name)

      expect(result).to eq(["published-trail"])
    end

    it "yields trails sorted by topic name" do
      create(:trail, :published, topic: create(:topic, name: "ZZZ"))
      create(:trail, :published, topic: create(:topic, name: "AAA"))

      result = run_query.map(&:topic_name)

      expect(result).to eq(["AAA", "ZZZ"])
    end

    def run_query
      result = []
      trails = TrailsForPracticePageQuery.new
      trails.each { |yielded| result << yielded }
      result
    end
  end
end
