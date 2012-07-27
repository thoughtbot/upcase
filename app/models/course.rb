class Course < ActiveRecord::Base
  validates_presence_of :name, :description, :price, :start_at, :stop_at, :maximum_students, :short_description, :audience_id

  belongs_to :audience
  has_many :sections
  has_many :questions, order: "created_at asc"
  has_many :follow_ups
  has_many :registrations, through: :sections
  has_many :classifications, as: :classifiable
  has_many :topics, through: :classifications

  accepts_nested_attributes_for :questions, reject_if: :all_blank
  accepts_nested_attributes_for :follow_ups, reject_if: :all_blank
  has_attached_file :course_image, {
    styles: { course: "313x220#" },
  }.merge(PAPERCLIP_STORAGE_OPTIONS)

  acts_as_list

  def self.by_position
    order("courses.position asc")
  end

  def self.unscheduled
    where("courses.id not in (select sections.course_id from sections where sections.ends_on >= ?)", Date.today)
  end

  def self.only_public
    where(public: true)
  end

  def self.for_topic(topic)
    joins(:classifications).where('classifications.topic_id' => topic.id)
  end

  def questions_with_blank
    questions + [questions.new]
  end

  def follow_ups_with_blank
    follow_ups + [follow_ups.new]
  end

  def active?
    active_section.present?
  end

  def active_section
    sections.active[0]
  end

  def active_date_range
    active_section.try(:date_range)
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def image_url
    raw_url = course_image.url(:course)
    course_image_file_name.nil? ? "/assets/#{raw_url}" : raw_url
  end
end
