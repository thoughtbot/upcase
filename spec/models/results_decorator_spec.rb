require 'spec_helper'

describe ResultsDecorator do
  let(:complete_collection) { [:item1, :item2, :item3] }
  let(:search_results) { [:item1] }

  describe '#all' do
    it 'returns the entire collection' do
      results = ResultsDecorator.new(complete_collection, search_results)
      results.all.should == [:item1, :item2, :item3]
    end
  end

  describe '#hidden' do
    it 'returns the items that were not found' do
      filtered_results = ResultsDecorator.new(complete_collection, search_results)
      filtered_results.hidden.should == [:item2, :item3]
    end
  end

  describe '#visible' do
    it 'should delegate to @filtered' do
      filtered_results = ResultsDecorator.new(complete_collection, search_results)
      filtered_results.visible.should == search_results
    end
  end
end
