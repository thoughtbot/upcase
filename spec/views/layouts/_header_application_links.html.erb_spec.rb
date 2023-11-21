require "rails_helper"

describe "layouts/_header_application_links.html.erb" do
  include Gravatarify::Helper

  let(:call_to_action_label) { "Get two months free" }

  it "renders the user's avatar" do
    email = generate(:email)

    view_stub_with_return(masquerading?: false)
    view_stub_with_return(signed_in?: true)
    view_stub_with_return(
      current_user: double("user", email: email),
    )
    render

    expect(rendered).to have_css(<<-CSS.strip)
      img[src='#{gravatar_url(email, size: "30")}']
    CSS
  end
end
