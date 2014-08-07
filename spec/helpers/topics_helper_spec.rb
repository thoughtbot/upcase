require "rails_helper"

describe TopicsHelper, '#format_content', type: :helper do
  let(:ellipsis) { '&#8230;' }

  it 'strips tags from content' do
    content   = '<strong>Hello</strong> there'
    expected  = 'Hello there'
    expect(helper.format_content(content)).to eq expected
  end

  it 'truncates the number of characters to max of 140' do
    content   = 'On the new learn homepage, the topic excerpts are too long. It would be additionally great to add a function into the view that controls the numbers of words present, so a designer can fool with it.'
    expected  = "On the new learn homepage, the topic excerpts are too long. It would be additionally great to add a function into the view that#{ellipsis}"
    expect(helper.format_content(content)).to eq expected
    expect(helper.format_content(content, length: 9, omission: "...")).to eq(
      "On the..."
    )
  end

  it 'does not include an ellipsis if the content is short' do
    content = 'Hello there.'
    expected = 'Hello there.'
    expect(helper.format_content(content)).to eq expected
  end
end
