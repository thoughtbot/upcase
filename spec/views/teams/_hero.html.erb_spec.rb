require "rails_helper"

describe "teams/_hero.html.erb" do
  include PlansHelper

  it "renders a link to the teams checkout" do
    render "teams/hero"

    expect(rendered).to have_link(
      t("subscriptions.join_cta"),
      href: team_checkout_path,
    )
  end
end
