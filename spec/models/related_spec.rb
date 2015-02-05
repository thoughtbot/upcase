require "rails_helper"

describe Related do
  it 'is initialized with an item' do
    Related.new(double)
  end

  describe 'to_partial_path' do
    it 'returns the proper partial path' do
      related = Related.new(double)
      expect(related.to_partial_path).to eq 'relateds/related'
    end
  end

  describe 'products' do
    it 'returns the ordered active products of the item' do
      ordered = spy("product")
      active = spy("product", active: ordered)
      item = spy("product", products: active)

      related = Related.new(item)
      related.products

      expect(item).to have_received(:products)
      expect(active).to have_received(:active)
      expect(ordered).to have_received(:ordered)
    end
  end

  describe 'video_tutorials' do
    it 'returns the active ordered video_tutorials of the item' do
      active = spy("product")
      item = spy("product", video_tutorials: active)

      related = Related.new(item)
      related.video_tutorials

      expect(item).to have_received(:video_tutorials)
      expect(active).to have_received(:active)
    end
  end

  describe 'topics' do
    it 'returns the related topics of the item' do
      item = spy("product", topics: [])

      related = Related.new(item)
      related.topics

      expect(item).to have_received(:topics)
    end
  end
end
