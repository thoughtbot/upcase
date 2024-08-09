require "rails_helper"

describe Search do
  describe "#results_with_excerpts" do
    it "returns relevant search results" do
      hello_video = create(:video, notes: "Hello world")
      other_video = create(:video, notes: "other video")
      populate_search_index

      results = run_search_for("hello")

      expect(results).to include(hello_video)
      expect(results).not_to include(other_video)
    end

    it "highlights the query in the excerpt" do
      create(:video, notes: "Hello world")
      populate_search_index

      results = run_search_for("hello")

      expect(rendered_excerpt(results)).to have_css(".highlight", text: "Hello")
    end

    it "sanitizes the query" do
      expect { run_search_for("hackers'); DROP TABLE users;") }
        .not_to raise_error
    end
  end

  def run_search_for(query)
    Search.new(query).results
  end

  def rendered_excerpt(results)
    Capybara.string(excerpts_for(results).first)
  end

  def excerpts_for(results)
    results.map(&:excerpt)
  end
end
