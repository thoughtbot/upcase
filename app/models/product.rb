class Product < ActiveRecord::Base
  has_many :purchases
  has_many :downloads
  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications

  validates_presence_of :name, :sku, :individual_price, :company_price, :fulfillment_method
  accepts_nested_attributes_for :downloads, :allow_destroy => true
  attr_accessor :wistia_hash, :video_sizes, :video_hash_id
  has_attached_file :product_image, {
    styles: { book: "230x300#", screencast: "153x100#" },
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  def self.active
    where(active: true)
  end

  def self.ordered
    order("name asc")
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def video_sizes
    @video_sizes ||= JSON.parse(wistia_hash)["assets"].inject({}){|result, asset| result.merge(asset["type"]=>human_file_size(asset['fileSize']))}
  rescue
    {}
  end

  def video_hash_id
    @video_hash_id ||= JSON.parse(wistia_hash)["hashed_id"] rescue nil
  end

  def wistia_hash
    @wistia_hash ||= Wistia.get_media_hash_from_id(wistia_id).to_json unless wistia_id.nil?
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
