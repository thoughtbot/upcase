class SubscriberLicense
  include ActiveModel::Model

  attr_reader :offering_type, :sku, :variant

  def initialize(attributes)
    @collection = attributes[:collection]
    @offering_type = attributes[:offering_type]
    @product_id = attributes[:product_id]
    @sku = attributes[:sku]
  end

  def collection?
    @collection
  end

  def to_param
    @product_id.to_s
  end
end
