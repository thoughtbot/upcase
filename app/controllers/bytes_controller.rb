class BytesController < ApplicationController
  def index
    @articles = Article.bytes.ordered.published
  end
end
