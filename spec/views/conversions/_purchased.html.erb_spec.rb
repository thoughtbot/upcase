require 'spec_helper'

describe 'conversions/_purchased.html.erb' do
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

  it 'loads the Google AdWords JavaScript library' do
    adwords_load_line = 'googleadservices.com/pagead/conversion.js'

    render

    expect(rendered).to include(adwords_load_line)
  end

  it 'records the conversion dollar amount in Google AdWords' do
    conversion_amount_line = "var google_conversion_value = #{purchase_amount}"

    render

    expect(rendered).to include(conversion_amount_line)
  end

  def purchase_amount
    99
  end

  def purchase_name
    'Workshops Subscription'
  end
end
