require "rails_helper"

describe TrailsForPracticePageQuery do
  describe "#call" do
    it "returns only published trails" do
      create(:trail, :published, name: "published-trail")
      create(:trail, :unpublished, name: "unpublished-trail")

      result = run_query.map(&:name)

      expect(result).to eq(["published-trail"])
    end

    it "returns trails sorted by topic name" do
      create(:trail, :published, topic: create(:topic, name: "ZZZ"))
      create(:trail, :published, topic: create(:topic, name: "AAA"))

      result = run_query.map(&:topic_name)

      expect(result).to eq(["AAA", "ZZZ"])
    end

    def run_query
      TrailsForPracticePageQuery.call
    end
  end
end
