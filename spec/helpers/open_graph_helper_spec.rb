require 'spec_helper'

describe OpenGraphHelper do
  before :each do
    helper.request.symbolized_path_parameters.
      merge!(controller: "subscriptions", action: "new")
  end

  it 'produces the desired open graph tags' do
    tags = helper.open_graph_tags
    tags.should =~ %r{og:image}
    tags.should =~ %r{og:url}
    tags.should =~ %r{og:title}
  end
end
