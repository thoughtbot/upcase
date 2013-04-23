require 'spec_helper'

describe AdwordsHelper, '#adwords_conversion_tracker' do
  it 'includes the conversion tracking javascript' do
    flash[:purchase_paid_price] = 10

    helper.adwords_conversion_tracker.should include 'conversion.js'
  end

  it 'returns nil if flash[:purchase_paid_price] is not set' do
    helper.adwords_conversion_tracker.should eq nil
  end
end
