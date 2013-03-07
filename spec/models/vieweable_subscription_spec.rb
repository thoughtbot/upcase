require 'spec_helper'

describe '#should_display_subscription_cta' do
  context 'when the user has an active subscription' do
    it 'returns false' do
      user = stub('user', has_active_subscription?: true)
      current_path = stub('path')

      ViewableSubscription.new(user, create(:subscribeable_product)).should_display_subscription_cta?(current_path).should be_false
    end
  end

  context 'when the user is an the subscription product path' do
    include Rails.application.routes.url_helpers

    it 'returns false' do
      user = stub('user', has_active_subscription?: false)
      subscription_product = create(:subscribeable_product)
      current_path = product_path(subscription_product)

      ViewableSubscription.new(user, subscription_product).should_display_subscription_cta?(current_path).should be_false
    end
  end

  context 'when user is nil' do
    it 'returns false' do
      user = nil
      subscription_product = create(:subscribeable_product)
      current_path = stub('path')

      ViewableSubscription.new(user, subscription_product).should_display_subscription_cta?(current_path).should be_false
    end
  end
end

describe 'to_param' do
  it 'delegates to the subscription' do
    subscription_product = create(:subscribeable_product)
    ViewableSubscription.new(stub('user'), subscription_product).to_param.should == subscription_product.to_param
  end
end
