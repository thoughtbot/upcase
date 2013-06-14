require 'spec_helper'

describe AdwordsHelper, '#adwords_conversion_tracker' do
  it 'includes the conversion tracking javascript' do
    helper.adwords_conversion_tracker(10).should include 'conversion.js'
  end
end
