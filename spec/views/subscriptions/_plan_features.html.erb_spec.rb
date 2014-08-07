require "spec_helper"

describe "subscriptions/_plan_features.html", type: :view do
  it "shows each workshop in the catalog" do
    workshop = build_stubbed(:workshop, name: "Best Workshop")
    catalog = stub(workshops: [workshop], books: [])

    render "subscriptions/plan_features", catalog: catalog

    expect(rendered).to have_content(workshop.name)
  end

  it "shows each book in the catalog" do
    book = build_stubbed(:book, name: "Best Book")
    catalog = stub(books: [book], workshops: [])

    render "subscriptions/plan_features", catalog: catalog

    expect(rendered).to have_content(book.name)
  end
end
