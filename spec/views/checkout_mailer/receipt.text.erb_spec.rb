require "rails_helper"

describe "checkout_mailer/receipt.text" do
  it "renders receipt with trails_url" do
    @checkout = build_stubbed(:checkout)

    render template: "checkout_mailer/receipt", checkout: @checkout

    expect(rendered).to include(trails_url)
  end
end
