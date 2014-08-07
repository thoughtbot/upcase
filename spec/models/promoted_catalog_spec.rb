require "rails_helper"

describe PromotedCatalog, type: :model do
  describe 'any method' do
    it 'delegates to catalog and calls promoted on the returned object' do
      book_relation = stub('book_relation', promoted: :some_books)
      catalog = stub('catalog', books: book_relation)
      promoted_catalog = PromotedCatalog.new(catalog)

      expect(promoted_catalog.books).to eq(:some_books)
      expect(book_relation).to have_received(:promoted)
    end
  end
end
