require "rails_helper"

describe "subscriptions/_plan_features.html" do
  it "shows each video_tutorial in the catalog" do
    video_tutorial = build_stubbed(:video_tutorial, name: "Best VideoTutorial")
    catalog = stub(video_tutorials: [video_tutorial], books: [])

    render "subscriptions/plan_features", catalog: catalog

    expect(rendered).to have_content(video_tutorial.name)
  end

  it "shows each book in the catalog" do
    book = build_stubbed(:book, name: "Best Book")
    catalog = stub(books: [book], video_tutorials: [])

    render "subscriptions/plan_features", catalog: catalog

    expect(rendered).to have_content(book.name)
  end
end
