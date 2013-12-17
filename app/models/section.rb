class Section < ActiveRecord::Base
  belongs_to :workshop
  has_many :paid_purchases, -> { where paid: true }, class_name: 'Purchase', as: :purchaseable
  has_many :purchases, as: :purchaseable, dependent: :destroy
  has_many :section_teachers
  has_many :teachers, through: :section_teachers
  has_many :unpaid_purchases, -> { where paid: false }, class_name: 'Purchase', as: :purchaseable
  has_many :announcements, as: :announceable, dependent: :destroy
  has_many :downloads, as: :purchaseable

  delegate :name, :description, :terms, :videos, :resources, :in_person?,
    :online?, :github_team, :fulfilled_with_github?, :length_in_days, :sku,
    :fulfillment_method, :subscription?, :offering_type,
    to: :workshop, allow_nil: true

  accepts_nested_attributes_for :section_teachers

  validates :address, presence: true
  validates :start_at, presence: true
  validates :starts_on, presence: true
  validates :stop_at, presence: true
  validate :must_have_at_least_one_teacher

  after_create :send_follow_up_emails
  after_create :send_teacher_notifications

  def self.active
    where(
      'sections.starts_on >= ? OR sections.ends_on IS NULL',
      Time.zone.today
    ).by_starts_on
  end

  def self.by_starts_on
    order('starts_on asc')
  end

  def self.by_starts_on_desc
    order('starts_on desc')
  end

  def self.in_active_workshop
    joins(:workshop).where(workshops: {active: true})
  end

  def self.unique_section_teachers_by_teacher
    all.map(&:section_teachers).flatten.uniq &:teacher
  end

  def self.upcoming
    where 'starts_on = ?', 1.week.from_now
  end

  def self.current
    where(
      'starts_on <= ? AND (? <= ends_on OR ends_on IS NULL)',
      Time.zone.today,
      Time.zone.today
    )
  end

  def self.send_surveys
    current.each &:send_surveys
  end

  def self.send_office_hours_reminders
    current.each &:send_office_hours_reminders
  end

  def announcement
    @announcement ||= announcements.current
  end

  def full?
    if seats_available.present?
      purchases.count >= seats_available
    else
      false
    end
  end

  def location
    [address, city, state, zip].compact.join ', '
  end

  def seats_available
    super || workshop.maximum_students
  end

  def send_surveys
    ending_student_emails.each do |email|
      WorkshopMailer.workshop_survey(self, email).deliver
    end
  end

  def send_office_hours_reminders
    current_student_emails.each do |email|
      WorkshopMailer.office_hours_reminder(self, email).deliver
    end
  end

  def time_range
    "#{start_at.to_s(:time).strip}-#{stop_at.to_s(:time).strip}"
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def purchase_for(user)
    workshop.purchases.paid.where(user_id: user).first
  end

  def upcoming?
    starts_on >= Time.zone.today
  end

  def starts_on(purchase_date = nil)
    if purchase_date && starts_immediately?
      purchase_date
    else
      self[:starts_on]
    end
  end

  def ends_on(purchase_date = nil)
    if purchase_date && starts_immediately?
      purchase_date + length_in_days.days
    else
      self[:ends_on]
    end
  end

  def starts_immediately?
    self[:ends_on].blank?
  end

  def collection?
    true
  end

  def to_aside_partial
    'sections/aside'
  end

  private

  def self.xml_content(document, tag_name)
    document.search(tag_name).first.try :content
  end

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
      WorkshopMailer.delay.teacher_notification(teacher.id, id)
    end
  end

  def ending_student_emails
    ending_paid_purchases.collect { |purchase| purchase.email }
  end

  def current_student_emails
    current_paid_purchases.collect { |purchase| purchase.email }
  end

  def current_paid_purchases
    paid_purchases.select { |purchase| purchase.active? }
  end

  def ending_paid_purchases
    paid_purchases.select do |purchase|
      purchase.ends_on == Time.zone.today
    end
  end
end
