require 'spec_helper'

describe '#should_display_subscription_cta' do
  include Rails.application.routes.url_helpers

  context 'when the user has an active subscription' do
    it 'returns false' do
      user = stub('user', has_active_subscription?: true)
      current_path = stub('path')

      ViewableSubscription.new(user, create(:subscribeable_product)).should_display_subscription_cta?(current_path).should be_false
    end
  end

  context 'when the user is an the subscription product path' do
    it 'returns false' do
      user = stub('user', has_active_subscription?: false)
      subscription_product = create(:subscribeable_product)
      current_path = product_path(subscription_product)

      ViewableSubscription.new(user, subscription_product).should_display_subscription_cta?(current_path).should be_false
    end
  end

  context 'when user is not signed in (current_user is nil)' do
    context 'and the user is not on the subscription page' do
      it 'returns true' do
        user = nil
        subscription_product = create(:subscribeable_product)
        current_path = stub('path')

        ViewableSubscription.new(user, subscription_product).should_display_subscription_cta?(current_path).should be_true
      end
    end

    context 'and the user is on the subscription page' do
      it 'returns false' do
        user = nil
        subscription_product = create(:subscribeable_product)
        current_path = product_path(subscription_product)

        ViewableSubscription.new(user, subscription_product).should_display_subscription_cta?(current_path).should be_false
      end
    end
  end

  context 'when user has not subscribed and is not viewing the subscription' do
    it 'returns true' do
      user = stub('user', has_active_subscription?: false)
      current_path = stub('path')
      subscription_product = stub('subscription_product')

      ViewableSubscription.new(user, subscription_product).should_display_subscription_cta?(current_path).should be_true
    end
  end
end

describe 'to_param' do
  it 'delegates to the subscription' do
    subscription_product = create(:subscribeable_product)
    ViewableSubscription.new(stub('user'), subscription_product).to_param.should == subscription_product.to_param
  end
end
