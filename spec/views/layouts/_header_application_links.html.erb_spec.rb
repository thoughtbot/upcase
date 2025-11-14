require "rails_helper"

RSpec.describe "layouts/_header_application_links.html.erb" do
  include Gravatarify::Helper

  it "renders the user's avatar" do
    user = build_stubbed(:user)
    view_stub_with_return(current_user: user)
    view_stub_with_return(signed_in?: true)

    render template: "layouts/_header_application_links"

    expected_url = gravatar_url(user.email, size: "30")
    expect(rendered).to have_css("img[src='#{expected_url}']")
  end
end
