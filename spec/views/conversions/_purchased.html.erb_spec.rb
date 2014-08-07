require 'rails_helper'

describe 'conversions/_purchased.html.erb', :type => :view do
  before do
    view_stubs(
      purchase_amount: purchase_amount,
      purchase_name: purchase_name
    )
  end

  it 'records the purchase amount and purchase name in Segment.io' do
    purchase_properties = {
      revenue: purchase_amount,
      label: purchase_name
    }.to_json

    render

    expect(rendered).to include(purchase_properties)
  end

  def purchase_amount
    99
  end

  def purchase_name
    'Workshops Subscription'
  end
end
