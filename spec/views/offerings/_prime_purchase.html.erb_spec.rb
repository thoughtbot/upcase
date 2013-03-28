require 'spec_helper'

describe 'offerings/_prime_purchase.html.erb' do
  it "tries to sell the user on Prime" do
    render_template should_display_subscription_cta?: true

    rendered.should include('Subscribe to')
  end

  it "does not sell the user on Prime if the CTA shouldn't be displayed" do
    render_template should_display_subscription_cta?: false

    rendered.should_not include('Subscribe to')
  end

  def render_template(viewable_subscription_properties)
    viewable_subscription =
      stub('viewable_subscription', viewable_subscription_properties)

    Mocha::Configuration.allow :stubbing_non_existent_method do
      view.stubs(subscription_product: build_stubbed(:subscribeable_product))
    end

    render(
      template: 'offerings/_prime_purchase',
      locals: { viewable_subscription: viewable_subscription }
    )
  end
end
