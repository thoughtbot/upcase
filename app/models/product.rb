class Product < ApplicationRecord
  extend FriendlyId

  has_many :classifications, as: :classifiable, dependent: :destroy
  has_many :topics, through: :classifications
  has_many :videos, as: :watchable, dependent: :destroy

  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :sku, presence: true
  validates :type, presence: true
  validates :slug, presence: true, uniqueness: true

  has_attached_file :product_image, {
    path: "products/:attachment/:id_partition/:style/:filename"
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  def self.active
    where active: true
  end

  def self.promoted
    where promoted: true
  end

  def self.ordered
    order 'name ASC'
  end

  def self.newest_first
    order 'created_at DESC'
  end

  def product_type_symbol
    type.underscore.to_sym
  end

  def to_param
    slug
  end

  def title
    "#{name}: a #{offering_type.humanize.downcase} by thoughtbot"
  end

  def offering_type
    type.underscore
  end

  def to_aside_partial
    "#{self.class.name.underscore.pluralize}/aside"
  end

  def published_videos
    videos.published
  end

  validates_attachment_content_type :product_image, content_type: /\Aimage\/.*\Z/
  attr_accessor :delete_product_image
  before_validation { product_image.clear if delete_product_image == "1" }
end
