class Workshop < ActiveRecord::Base
  # Associations
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :classifications, as: :classifiable
  has_many :follow_ups
  has_many :questions, order: 'created_at ASC'
  has_many :purchases, through: :sections
  has_many :sections
  has_many :topics, through: :classifications
  has_many :videos, as: :watchable

  # Nested Attributes
  accepts_nested_attributes_for :follow_ups, reject_if: :all_blank
  accepts_nested_attributes_for :questions, reject_if: :all_blank

  # Validations
  validates :description, presence: true
  validates :maximum_students, presence: true
  validates :name, presence: true
  validates :individual_price, presence: true
  validates :company_price, presence: true
  validates :short_description, presence: true
  validates :start_at, presence: true
  validates :stop_at, presence: true

  # Plugins
  acts_as_list

  def active_section
    sections.active[0]
  end

  def active_sections
    sections.active
  end

  def alternate_company_price
    self[:alternate_company_price] || company_price
  end

  def alternate_individual_price
    self[:alternate_individual_price] || individual_price
  end

  def announcement
    @announcement ||= announcements.current
  end

  def as_json(options = {})
    options ||= {}
    super(options.merge(:methods => [:active_sections]))
  end

  def self.by_position
    order 'workshops.position ASC'
  end

  def follow_ups_with_blank
    follow_ups + [follow_ups.new]
  end

  def has_in_person_workshop?
    in_person_workshop.present?
  end

  def has_online_workshop?
    online_workshop.present?
  end

  def self.in_person
    where online: false
  end

  def in_person?
    ! online?
  end

  def in_person_workshop
    if online?
      self.class.in_person.find_by_name(name)
    end
  end

  def self.online
    where online: true
  end

  def online_workshop
    if in_person?
      self.class.online.find_by_name(name)
    end
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
      workshops.id NOT IN (
        SELECT sections.workshop_id
        FROM sections
        WHERE sections.ends_on >= ?
      )
    SQL

    where sql, Date.today
  end
end
