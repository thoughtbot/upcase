class Product < ActiveRecord::Base
  has_many :purchases
  has_many :downloads
  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications
  has_many :videos

  validates_presence_of :name, :sku, :individual_price, :company_price, :fulfillment_method
  accepts_nested_attributes_for :downloads, :allow_destroy => true
  has_attached_file :product_image, {
    styles: { book: "230x300#", screencast: "153x100#" },
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  def self.active
    where(active: true)
  end

  def self.ordered
    order("name asc")
  end

  def self.books
    where("product_type LIKE '%book%'")
  end

  def self.screencasts
    where("product_type LIKE '%screencast%'")
  end

  def self.for_topic(topic)
    joins(:classifications).where('classifications.topic_id' => topic.id)
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

  private

  def human_file_size num
    helpers.number_to_human_size(num)
  end

  def helpers
    ActionController::Base.helpers
  end

end
