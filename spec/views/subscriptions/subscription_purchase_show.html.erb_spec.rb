require 'spec_helper'

describe 'subscriptions/subscription_purchase_show.erb' do
  it 'tracks a conversion on Google AdWords' do
    @purchase = create(:purchase)
    @purchaseable = @purchase.purchaseable

    render

    rendered.should include adwords_conversion_tracker(@purchase.paid_price)
  end
end
