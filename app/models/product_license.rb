class ProductLicense
  include ActiveModel::Model

  attr_reader :original_price, :offering_type, :price, :sku, :variant

  def initialize(attributes)
    @offering_type = attributes[:offering_type]
    @original_price = attributes[:original_price]
    @price = attributes[:price]
    @product_id = attributes[:product_id]
    @sku = attributes[:sku]
    @variant = attributes[:variant]
  end

  def to_param
    @product_id.to_s
  end
end
