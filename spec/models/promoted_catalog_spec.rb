require "rails_helper"

describe PromotedCatalog do
  describe 'any method' do
    it 'delegates to catalog and calls promoted on the returned object' do
      screencast_relation = stub('screencast_relation', promoted: :some_screencasts)
      catalog = stub('catalog', screencasts: screencast_relation)
      promoted_catalog = PromotedCatalog.new(catalog)

      expect(promoted_catalog.screencasts).to eq(:some_screencasts)
      expect(screencast_relation).to have_received(:promoted)
    end
  end
end
