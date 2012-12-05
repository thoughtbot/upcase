class Product < ActiveRecord::Base
  # Associations
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :classifications, as: :classifiable
  has_many :downloads, as: :purchaseable
  has_many :purchases, as: :purchaseable
  has_many :topics, through: :classifications
  has_many :videos, as: :purchaseable

  # Nested Attributes
  accepts_nested_attributes_for :downloads, allow_destroy: true

  # Validations
  validates :name, presence: true
  validates :fulfillment_method, presence: true
  validates :sku, presence: true

  # Plugins
  has_attached_file :product_image, {
    styles: {
      book: '230x300#',
      video: '153x100#'
    }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  def self.active
    where active: true
  end

  def announcement
    @announcement ||= announcements.current
  end

  def meta_keywords
    topics.map { |topic| topic.name }.join(', ')
  end

  def self.books
    where product_type: 'book'
  end

  def self.videos
    where product_type: 'video'
  end

  def self.workshops
    where product_type: 'workshop'
  end

  def self.ordered
    order 'name ASC'
  end

  def announcement
    @announcement ||= announcements.current
  end

  def external?
    fulfillment_method == 'external'
  end

  def send_registration_emails(purchase)
  end

  def image_url
    raw_url = self.product_image.url(product_type_symbol)
    product_image_file_name? ? raw_url : "/assets/#{raw_url}"
  end

  def product_type_symbol
    self.product_type.split(' ')[0].downcase.to_sym
  rescue
    'book'
  end

  def self.promoted(location)
    where(promo_location: location).first
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def individual_price
    apply_discount(original_individual_price).to_i
  end

  def company_price
    apply_discount(original_company_price).to_i
  end

  def original_company_price
    self[:company_price] || 0
  end

  def original_individual_price
    self[:individual_price] || 0
  end

  def discounted?
    discount_percentage > 0
  end

  private

  def apply_discount(price)
    price - (price * discount_percentage * 0.01)
  end
end
