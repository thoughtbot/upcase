class Product < ActiveRecord::Base
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :classifications, as: :classifiable
  has_many :downloads, as: :purchaseable
  has_many :purchases, as: :purchaseable
  has_many :topics, through: :classifications

  accepts_nested_attributes_for :downloads, allow_destroy: true

  validates :name, presence: true
  validates :fulfillment_method, presence: true
  validates :sku, presence: true
  validates :type, presence: true

  has_attached_file :product_image, {
    styles: {
      book: '230x300#',
      screencast: '153x100#'
    },
    path: "products/:attachment/:id_partition/:style/:filename"
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  def self.active
    where active: true
  end

  def self.ordered
    order 'name ASC'
  end

  def self.newest_first
    order 'created_at DESC'
  end

  def meta_keywords
    topics.meta_keywords
  end

  def announcement
    @announcement ||= announcements.current
  end

  def subscription?
    false
  end

  def image_url
    raw_url = product_image.url(product_type_symbol)
    product_image_file_name? ? raw_url : "/assets/#{raw_url}"
  end

  def product_type_symbol
    type.underscore.to_sym
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def individual_price
    apply_discount(original_individual_price)
  end

  def company_price
    apply_discount(original_company_price)
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

  def starts_on(purchase_date)
    purchase_date
  end

  def ends_on(purchase_date)
    purchase_date
  end

  def purchase_for(user)
    purchases.paid.where(user_id: user).first
  end

  def title
    "#{name}: a #{type.downcase} by thoughtbot"
  end

  def offering_type
    type.downcase
  end

  def alternates
    []
  end

  def fulfilled_with_github?
    github_team.present?
  end

  def collection?
    false
  end

  def to_aside_partial
    "#{self.class.name.underscore.pluralize}/aside"
  end

  def licenses_for(user)
    if user.present? && user.has_active_subscription?
      [subscriber_license]
    else
      product_licenses
    end
  end

  def fulfill(purchase, user)
    GithubFulfillment.new(purchase).fulfill
  end

  private

  def apply_discount(price)
    price - (price * discount_percentage * 0.01)
  end

  def subscriber_license
    SubscriberLicense.new(
      collection: collection?,
      offering_type: offering_type,
      product_id: id,
      sku: sku
    )
  end

  def product_licenses
    [
      ProductLicense.new(
        discounted: discounted?,
        offering_type: offering_type,
        original_price: original_individual_price,
        price: individual_price,
        product_id: id,
        sku: sku,
        variant: :individual
      ),
      ProductLicense.new(
        discounted: discounted?,
        offering_type: offering_type,
        original_price: original_company_price,
        price: company_price,
        product_id: id,
        sku: sku,
        variant: :company
      )
    ]
  end
end
