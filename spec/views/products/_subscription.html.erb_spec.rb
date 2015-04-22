require "rails_helper"

describe "products/_subscription.html.erb" do
  it "tries to sell the user on Upcase" do
    current_user_has_subscription = false
    render_template current_user_has_subscription

    expect(rendered).to include("Subscribe to")
  end

  it "does not sell the user on Upcase if the CTA shouldn't be displayed" do
    current_user_has_subscription = true
    render_template current_user_has_subscription

    expect(rendered).not_to include("Subscribe to")
  end

  def render_template(current_user_has_subscription)
    product = double("product", offering_type: "show")

    allow(view).to receive(:current_user_has_active_subscription?).
      and_return(current_user_has_subscription)

    render(
      template: "products/_subscription",
      locals: { offering: product }
    )
  end
end
