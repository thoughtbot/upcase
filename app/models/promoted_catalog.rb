class PromotedCatalog
  def initialize(catalog)
    @catalog = catalog
  end

  def method_missing(message, *arguments)
    catalog.send(message, *arguments).promoted
  end

  def respond_to_missing?(message, include_all = false)
    catalog.send(:respond_to?, message, include_all)
  end

  private

  attr_reader :catalog
end
