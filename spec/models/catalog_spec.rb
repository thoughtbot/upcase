require 'spec_helper'

describe Catalog do
  describe '#books' do
    it 'returns active books in order' do
      catalog = Catalog.new
      expect(catalog.books).to find_relation(Book.active.ordered)
    end
  end

  describe '#in_person_workshops' do
    it 'returns active in-person workshops in order' do
      catalog = Catalog.new
      expect(catalog.in_person_workshops).
        to find_relation(Workshop.only_active.by_position.in_person)
    end
  end

  describe '#online_workshops' do
    it 'returns active online workshops in order' do
      catalog = Catalog.new
      expect(catalog.online_workshops).
        to find_relation(Workshop.only_active.by_position.online)
    end
  end

  describe '#screencasts' do
    it 'returns active screencasts with the most recent first' do
      catalog = Catalog.new
      expect(catalog.screencasts).
        to find_relation(Screencast.active.newest_first)
    end
  end

  describe '#shows' do
    it 'returns active shows by name' do
      catalog = Catalog.new
      expect(catalog.shows).to find_relation(Show.active.ordered)
    end
  end

  describe '#to_partial_path' do
    it 'returns a renderable path' do
      catalog = Catalog.new
      expect(catalog.to_partial_path).to eq('catalogs/catalog')
    end
  end
end
