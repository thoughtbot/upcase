require "rails_helper"

describe Related do
  it 'is initialized with an item' do
    Related.new(stub)
  end

  describe 'to_partial_path' do
    it 'returns the proper partial path' do
      related = Related.new(stub)
      expect(related.to_partial_path).to eq 'relateds/related'
    end
  end

  describe 'products' do
    it 'returns the ordered active products of the item' do
      ordered = stub(:ordered)
      active = stub(active: ordered)
      item = stub(products: active)

      related = Related.new(item)
      related.products

      expect(item).to have_received(:products)
      expect(active).to have_received(:active)
      expect(ordered).to have_received(:ordered)
    end
  end

  describe 'video_tutorials' do
    it 'returns the active ordered video_tutorials of the item' do
      by_position = stub(:by_position)
      only_active = stub(only_active: by_position)
      item = stub(video_tutorials: only_active)

      related = Related.new(item)
      related.video_tutorials

      expect(item).to have_received(:video_tutorials)
      expect(only_active).to have_received(:only_active)
      expect(by_position).to have_received(:by_position)
    end
  end

  describe 'topics' do
    it 'returns the related topics of the item' do
      item = stub(topics: [])

      related = Related.new(item)
      related.topics

      expect(item).to have_received(:topics)
    end
  end
end
