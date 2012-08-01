require 'spec_helper'

describe NullArticle, '#to_partial_path' do
  it 'returns correct path to partial' do
    NullArticle.new.to_partial_path == 'articles/null_article'
  end
end
