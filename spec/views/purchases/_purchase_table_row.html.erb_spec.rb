require 'spec_helper'

describe 'purchases/_purchase_table_row.html.erb' do
  it 'renders purchase information' do
    purchase = create(:paid_purchase)

    render 'purchases/purchase_table_row', purchase: purchase

    expect(rendered).to include(link_to(purchase.purchaseable_name, purchase))
    expect(rendered).to include(purchase.created_at.to_s(:short_date))
    expect(rendered).to include(number_to_currency(purchase.price))
    expect(rendered).to include(
      t("purchases.payment_methods.#{purchase.payment_method}")
    )
  end
end
