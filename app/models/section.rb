class Section < ActiveRecord::Base
  # Associations
  belongs_to :workshop
  has_many :paid_purchases, class_name: 'Purchase', as: :purchaseable,
    conditions: { paid: true }
  has_many :purchases, as: :purchaseable
  has_many :section_teachers
  has_many :teachers, through: :section_teachers
  has_many :unpaid_purchases, class_name: 'Purchase', as: :purchaseable,
    conditions: { paid: false }
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :downloads, as: :purchaseable
  has_many :videos, as: :purchaseable

  # Delegates
  delegate :name, :description, :individual_price, :company_price, :terms,
    to: :workshop

  # Nested Attributes
  accepts_nested_attributes_for :section_teachers

  # Validations
  validates :address, presence: true
  validates :ends_on, presence: true
  validates :start_at, presence: true
  validates :starts_on, presence: true
  validates :stop_at, presence: true
  validate :must_have_at_least_one_teacher

  # Callbacks
  after_create :send_follow_up_emails
  after_create :send_teacher_notifications

  def self.active
    where("sections.ends_on >= ?", Date.today).by_starts_on
  end

  def self.by_starts_on
    order("starts_on asc")
  end

  def self.by_starts_on_desc
    order('starts_on desc')
  end

  def self.in_public_workshop
    joins(:workshop).where(workshops: {public: true})
  end

  def send_registration_emails(purchase)
    SendRegistrationEmailsJob.enqueue(purchase.id)
  end

  def announcement
    @announcement ||= announcements.current
  end

  def fulfillment_method
    'in-person'
  end

  def product_type
    'workshop'
  end

  def date_range
    if starts_on == ends_on
      starts_on.to_s :simple
    elsif starts_on.year != ends_on.year
      "#{starts_on.to_s(:simple)}-#{ends_on.to_s(:simple)}"
    elsif starts_on.month != ends_on.month
      "#{starts_on.strftime('%B %d')}-#{ends_on.to_s(:simple)}"
    else
      "#{starts_on.strftime('%B %d')}-#{ends_on.strftime('%d, %Y')}"
    end
  end

  def full?
    purchases.count >= seats_available
  end

  def location
    [address, city, state, zip].compact.join ', '
  end

  def seats_available
    super || workshop.maximum_students
  end

  def self.send_reminders
    upcoming.each &:send_reminders
  end

  def send_reminders
    paid_purchases.each do |purchase|
      Mailer.section_reminder(purchase, self).deliver
    end
  end

  def time_range
    "#{start_at.to_s(:time).strip}-#{stop_at.to_s(:time).strip}"
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def self.unique_section_teachers_by_teacher
    all.map(&:section_teachers).flatten.uniq &:teacher
  end

  def self.upcoming
    where 'starts_on = ?', 1.week.from_now
  end

  private

  def must_have_at_least_one_teacher
    unless teachers.any?
      errors.add :base, 'must specify at least one teacher'
    end
  end

  def send_follow_up_emails
    workshop.follow_ups.have_not_notified.each do |follow_up|
      follow_up.notify self
    end
  end

  def send_teacher_notifications
    teachers.each do |teacher|
      Mailer.teacher_notification(teacher, self).deliver
    end
  end

  def self.xml_content(document, tag_name)
    document.search(tag_name).first.try :content
  end
end
