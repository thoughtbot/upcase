require 'spec_helper'

describe 'purchases/index.html.erb' do
  it 'renders table rows for every purchase' do
    purchases = build_stubbed_list(:purchase, 2, lookup: 'whatever')
    assign :purchases, purchases

    render template: 'purchases/index'

    purchase_table_rows = render(
      partial: 'purchases/purchase_table_row',
      collection: purchases,
      as: :purchase
    )

    expect(rendered).to include(purchase_table_rows)
  end
end
