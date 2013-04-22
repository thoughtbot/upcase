require 'spec_helper'

describe 'workshops/workshop_purchase_show.html.erb' do
  it 'tracks a conversion on Google AdWords' do
    @purchaseable = create(:section)
    @purchase = create(:purchase)

    render

    rendered.should include adwords_conversion_tracker(@purchase.paid_price)
  end
end
