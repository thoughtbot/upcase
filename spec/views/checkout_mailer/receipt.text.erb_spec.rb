require "rails_helper"

describe "checkout_mailer/receipt.text" do
  it "renders receipt with practice_url" do
    @checkout = build_stubbed(:checkout)

    render template: "checkout_mailer/receipt", checkout: @checkout

    expect(rendered).to include(practice_url)
  end
end
