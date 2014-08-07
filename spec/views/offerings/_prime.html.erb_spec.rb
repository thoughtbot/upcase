require "spec_helper"

describe "offerings/_prime.html.erb", type: :view do
  it "tries to sell the user on Prime" do
    current_user_has_subscription = false
    render_template current_user_has_subscription

    expect(rendered).to include("Subscribe to")
  end

  it "does not sell the user on Prime if the CTA shouldn't be displayed" do
    current_user_has_subscription = true
    render_template current_user_has_subscription

    expect(rendered).not_to include("Subscribe to")
  end

  def render_template(current_user_has_subscription)
    product = stub("product", offering_type: "book")

    Mocha::Configuration.allow :stubbing_non_existent_method do
      view.stubs(
        current_user_has_active_subscription?: current_user_has_subscription
      )
    end

    render(
      template: "offerings/_prime",
      locals: { offering: product }
    )
  end
end
