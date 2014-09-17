require "rails_helper"

describe "subscriptions/_plan_features.html" do
  it "shows each video_tutorial in the catalog" do
    video_tutorial = build_stubbed(:video_tutorial, name: "Best VideoTutorial")
    catalog = stub(video_tutorials: [video_tutorial])

    render "subscriptions/plan_features", catalog: catalog

    expect(rendered).to have_content(video_tutorial.name)
  end
end
