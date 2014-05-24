require 'spec_helper'

describe PromotedCatalog do
  describe 'any method' do
    it 'delegates to catalog and calls promoted on the returned object' do
      book_relation = double('book_relation', promoted: :some_books)
      catalog = double('catalog', books: book_relation)
      promoted_catalog = PromotedCatalog.new(catalog)

      expect(promoted_catalog.books).to eq(:some_books)
      expect(book_relation).to have_received(:promoted)
    end
  end
end
