class Product < ActiveRecord::Base
  has_many :purchases
  has_many :downloads
  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications
  has_many :videos

  validates_presence_of :name, :sku, :individual_price, :company_price, :fulfillment_method
  accepts_nested_attributes_for :downloads, :allow_destroy => true
  has_attached_file :product_image, {
    styles: { book: '230x300#', video: '153x100#' }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  def self.active
    where(active: true)
  end

  def self.books
    where product_type: 'book'
  end

  def self.ordered
    order("name asc")
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def product_type_symbol
    self.product_type.split(" ")[0].downcase.to_sym
  rescue
    "book"
  end

  def image_url
    raw_url = self.product_image.url(product_type_symbol)
    product_image_file_name.nil? ? "/assets/#{raw_url}" : raw_url
  end

  def external?
    fulfillment_method == 'external'
  end

  def self.videos
    where product_type: 'video'
  end
end
