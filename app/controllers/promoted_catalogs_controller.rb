class PromotedCatalogsController < ApplicationController
  layout 'empty-body'

  def show
    @catalog = PromotedCatalog.new(Catalog.new)
  end
end
