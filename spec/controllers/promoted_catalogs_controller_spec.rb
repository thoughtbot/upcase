require 'spec_helper'

describe PromotedCatalogsController do
  describe '#show' do
    it 'uses the empty-body layout' do
      promoted_catalog = stub('promoted_catalog')
      PromotedCatalog.stubs(:new).returns(promoted_catalog)
      get :show

      expect(response).to render_template('layouts/empty-body')
      expect(assigns(:catalog)).to eq(promoted_catalog)
      expect(PromotedCatalog).to have_received(:new).with(instance_of(Catalog))
    end
  end
end
