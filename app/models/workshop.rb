class Workshop < ActiveRecord::Base
  # Associations
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :classifications, as: :classifiable, dependent: :destroy
  has_many :follow_ups, dependent: :destroy
  has_many :questions, order: 'created_at ASC', dependent: :destroy
  has_many :purchases, through: :sections
  has_many :sections
  has_many :topics, through: :classifications
  has_many :videos, as: :watchable
  has_many :events, dependent: :destroy

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

  def purchase_for(user)
    purchases.paid.where(user_id: user).first
  end
end
