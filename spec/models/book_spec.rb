require 'spec_helper'

describe Book, :type => :model do
  describe '#filename' do
    it 'returns the parameterized product name' do
      book = Book.new(name: 'Backbone.js on Rails')
      expect(book.filename).to eq 'backbone-js-on-rails'
    end
  end

  it_behaves_like 'a class inheriting from Product'
end
