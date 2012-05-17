class Product < ActiveRecord::Base
  has_many :purchases
  has_many :downloads
  validates_presence_of :name, :sku, :individual_price, :company_price, :fulfillment_method
  accepts_nested_attributes_for :downloads, :allow_destroy => true
  before_save :update_wistia_hash

  def self.active
    where(active: true)
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def video_sizes
    JSON.parse(wistia_hash)["assets"].inject({}){|result, asset| result.merge(asset["type"]=>human_file_size(asset['fileSize']))}
  end

  def video_hash_id
    JSON.parse(wistia_hash)["hashed_id"]
  end
  private

  def human_file_size num
    helpers.number_to_human_size(num)
  end

  def helpers
    ActionController::Base.helpers
  end


  def update_wistia_hash
    self.wistia_hash = Wistia.get_media_hash_from_id(wistia_id).to_json unless wistia_id.nil?
  end
end
