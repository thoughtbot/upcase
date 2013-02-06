require 'spec_helper'

describe 'subscriber/purchases/show.html.erb' do
  context 'when the product is a book product' do
    it 'displays a link to the GitHub repository' do
      product = build_stubbed(:book_product, github_url: 'http://github.com/thoughtbot/WE-WRITE-BOOKS')
      assign(:purchaseable, product)

      render

      render.should include(product.github_url)
    end
  end
end
