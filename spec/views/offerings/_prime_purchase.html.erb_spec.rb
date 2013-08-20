require 'spec_helper'

describe 'offerings/_prime_purchase.html.erb' do
  it "tries to sell the user on Prime" do
    current_user_has_subscription = false
    render_template current_user_has_subscription

    rendered.should include('Subscribe to')
  end

  it "does not sell the user on Prime if the CTA shouldn't be displayed" do
    current_user_has_subscription = true
    render_template current_user_has_subscription

    rendered.should_not include('Subscribe to')
  end

  def render_template(current_user_has_subscription)
    product = stub('product', offering_type: 'book')

    Mocha::Configuration.allow :stubbing_non_existent_method do
      view.stubs(
        current_user_has_active_subscription?: current_user_has_subscription
      )
    end

    render(
      template: 'offerings/_prime_purchase',
      locals: { offering: product }
    )
  end
end
