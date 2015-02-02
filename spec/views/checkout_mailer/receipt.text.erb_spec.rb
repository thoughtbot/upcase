require "rails_helper"

describe "checkout_mailer/receipt.text" do
  it "renders receipt with trails_url" do
    @plan = build_stubbed(:plan)

    render template: "checkout_mailer/receipt", plan: @plan

    expect(rendered).to include(trails_url)
  end
end
