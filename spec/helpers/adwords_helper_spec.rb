require 'spec_helper'

describe AdwordsHelper, '#adwords_conversion_tracker' do
  it 'includes the conversion tracking javascript' do
    helper.adwords_conversion_tracker(10).should include 'conversion.js'
  end

  it 'returns nil if the value is not present' do
    helper.adwords_conversion_tracker(nil).should eq nil
  end
end
