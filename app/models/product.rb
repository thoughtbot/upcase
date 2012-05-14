class Product < ActiveRecord::Base
  has_many :purchases
  has_many :downloads
  validates_presence_of :name, :sku, :individual_price, :company_price, :fulfillment_method
  accepts_nested_attributes_for :downloads, :allow_destroy => true

  def self.active
    where(active: true)
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
