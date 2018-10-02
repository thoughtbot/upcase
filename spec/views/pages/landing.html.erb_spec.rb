require "rails_helper"

RSpec.describe "pages/landing.html.erb" do
  it "renders links to the practice page" do
    render

    expect(rendered).to have_link href: "/upcase/practice", count: 3
  end
end
