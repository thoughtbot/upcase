require "rails_helper"

describe "trails/_completeable_preview.html" do
  include TrailHelpers

  it "links to the completeable page" do
    completeable = build_completeable_with_progress

    render "trails/completeable_preview", completeable: completeable

    expect(rendered).to have_link_to(url_for(completeable))
  end
end
