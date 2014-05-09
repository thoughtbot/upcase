class Product < ActiveRecord::Base
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :classifications, as: :classifiable
  has_many :downloads, as: :purchaseable
  has_many :purchases, as: :purchaseable
  has_many :topics, through: :classifications
  has_many :videos, as: :watchable, dependent: :destroy

  accepts_nested_attributes_for :downloads, allow_destroy: true

  validates :name, presence: true
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

  def self.promoted
    where promoted: true
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

  def after_purchase_url(controller, purchase)
    controller.purchase_path(purchase)
  end

  def published_videos
    videos.published
  end

  private

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
        offering_type: offering_type,
        original_price: individual_price,
        price: individual_price,
        product_id: id,
        sku: sku,
        variant: :individual
      ),
      ProductLicense.new(
        offering_type: offering_type,
        original_price: company_price,
        price: company_price,
        product_id: id,
        sku: sku,
        variant: :company
      )
    ]
  end
end
