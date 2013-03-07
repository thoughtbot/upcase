require 'spec_helper'

describe 'products/_prime_purchase.html.erb' do
  it "tries to sell the user on Prime" do
    Mocha::Configuration.allow :stubbing_non_existent_method do
      view.stubs(currently_viewing_subscription_product?: false)
      view.stubs(current_user_has_active_subscription?: false)
      view.stubs(subscription_product: stub('subscription_product', name: 'foo'))

      render template: 'products/_prime_purchase'

      rendered.should include(I18n.t('shared.subscription_call_to_action'))
    end
  end

  it "does not sell the user on Prime if they're subscribed already" do
    Mocha::Configuration.allow :stubbing_non_existent_method do
      view.stubs(currently_viewing_subscription_product?: false)
      view.stubs(current_user_has_active_subscription?: true)
      view.stubs(subscription_product: stub('subscription_product'))

      render template: 'products/_prime_purchase'

      rendered.should_not include(I18n.t('shared.subscription_call_to_action'))
    end
  end

  it "does not sell the user on Prime if they're currently viewing Prime's product show page" do
    Mocha::Configuration.allow :stubbing_non_existent_method do
      view.stubs(currently_viewing_subscription_product?: true)

      render template: 'products/_prime_purchase'

      rendered.should_not include(I18n.t('shared.subscription_call_to_action'))
    end
  end
end
