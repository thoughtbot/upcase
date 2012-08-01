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

  def self.find_all_books_or_by_topics(topics)
    reduction = lambda {|memo, topic| memo + books.for_topic(topic).active }
    found_books = topics.reduce([], &reduction).uniq
    found_books = books.active if found_books.blank?
    found_books
  end

  def self.find_all_screencasts_or_by_topics(topics)
    reduction = lambda {|memo, topic| memo + screencasts.for_topic(topic).active }
    found_screencasts = topics.reduce([], &reduction).uniq
    found_screencasts = screencasts.active if found_screencasts.blank?
    found_screencasts
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
end
