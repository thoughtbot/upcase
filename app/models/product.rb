class Product < ActiveRecord::Base
  has_many :purchases

  validates_presence_of :name, :sku, :individual_price, :company_price, :fulfillment_method

  def self.active
    where(active: true)
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
