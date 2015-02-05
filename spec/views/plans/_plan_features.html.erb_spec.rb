require "rails_helper"

describe "plans/_plan_features.html" do
  it "shows each video_tutorial in the catalog" do
    video_tutorial = build_stubbed(:video_tutorial, name: "Best VideoTutorial")
    catalog = double("catalog", video_tutorials: [video_tutorial])

    render "plans/plan_features", catalog: catalog

    expect(rendered).to have_content(video_tutorial.name)
  end
end
