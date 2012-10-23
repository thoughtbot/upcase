require 'spec_helper'

describe OpenGraphHelper do
  it 'produces the desired open graph tags' do
    tags = helper.open_graph_tags
    tags.should =~ %r{og:image}
    tags.should =~ %r{og:url}
    tags.should =~ %r{og:title}
  end
end
