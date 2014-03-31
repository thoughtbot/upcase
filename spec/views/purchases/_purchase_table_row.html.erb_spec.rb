require 'spec_helper'

describe 'purchases/_purchase_table_row.html.erb' do
  it 'renders purchase information' do
    purchase = create(:paid_purchase)

    render 'purchases/purchase_table_row', purchase: purchase

    rendered.should include(link_to(purchase.purchaseable_name, purchase))
    rendered.should include(purchase.created_at.to_s(:short_date))
    rendered.should include(number_to_currency(purchase.price))
    rendered.should include(
      t("purchases.payment_methods.#{purchase.payment_method}")
    )
  end
end
