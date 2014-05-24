require 'spec_helper'

describe OpenGraphHelper do
  before :each do
    helper.request.symbolized_path_parameters.
      merge!(controller: 'homes', action: 'show')
  end

  it 'produces the desired open graph tags' do
    tags = helper.open_graph_tags
    expect(tags).to match(%r{og:image})
    expect(tags).to match(%r{og:url})
    expect(tags).to match(%r{og:title})
  end
end
