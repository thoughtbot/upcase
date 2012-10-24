class Course < ActiveRecord::Base
  # Associations
  belongs_to :audience
  has_many :classifications, as: :classifiable
  has_many :follow_ups
  has_many :questions, order: 'created_at ASC'
  has_many :registrations, through: :sections
  has_many :sections
  has_many :topics, through: :classifications

  # Nested Attributes
  accepts_nested_attributes_for :follow_ups, reject_if: :all_blank
  accepts_nested_attributes_for :questions, reject_if: :all_blank

  # Validations
  validates :audience_id, presence: true
  validates :description, presence: true
  validates :maximum_students, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :short_description, presence: true
  validates :start_at, presence: true
  validates :stop_at, presence: true

  # Plugins
  acts_as_list

  has_attached_file :course_image, {
    styles: {
      course: '313x220#'
    },
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  def active_section
    sections.active[0]
  end

  def active_sections
    sections.active
  end

  def as_json(options = {})
    options ||= {}
    super(options.merge(:methods => [:active_sections]))
  end

  def self.by_position
    order 'courses.position ASC'
  end

  def follow_ups_with_blank
    follow_ups + [follow_ups.new]
  end

  def image_url
    raw_url = course_image.url(:course)
    course_image_file_name? ? raw_url : "/assets/#{raw_url}"
  end

  def self.only_public
    where public: true
  end

  def self.promoted(location)
    where(promo_location: location).first
  end

  def questions_with_blank
    questions + [questions.new]
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def self.unscheduled
    sql = <<-SQL
      courses.id NOT IN (
        SELECT sections.course_id
        FROM sections
        WHERE sections.ends_on >= ?
      )
    SQL

    where sql, Date.today
  end
end
