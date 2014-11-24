require "rails_helper"

describe "explore/_all_trails.html" do
  it "renders a class based on the exercise state" do
    topic = build_stubbed(:topic, slug: "Refactoring Topic")
    trails = [build_stubbed(:trail, name: "Refactoring Trail", topic: topic)]

    render "explore/all_trails", trails: trails

    expect(rendered).to have_css("li.refactoring-topic")
    expect(rendered).to have_content("Refactoring Trail")
  end
end
