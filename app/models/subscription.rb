# This class represents a user or team's subscription to Learn content
class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan, polymorphic: true

  has_one :team, dependent: :destroy, class_name: 'Teams::Team'

  delegate :includes_mentor?, to: :plan
  delegate :includes_workshops?, to: :plan
  delegate :name, to: :plan, prefix: true
  delegate :stripe_customer_id, to: :user

  validates :plan_id, presence: true
  validates :plan_type, presence: true
  validates :user_id, presence: true

  def self.deliver_welcome_emails
    recent.each do |subscription|
      subscription.deliver_welcome_email
    end
  end

  def self.paid
    where(paid: true)
  end

  def self.canceled_in_last_30_days
    canceled_within_period(30.days.ago, Time.zone.now)
  end

  def self.active_as_of(time)
    where('deactivated_on is null OR deactivated_on > ?', time)
  end

  def self.created_before(time)
    where('created_at <= ?', time)
  end

  def self.next_payment_in_2_days
    where(next_payment_on: 2.days.from_now)
  end

  def active?
    deactivated_on.nil?
  end

  def deactivate
    SubscriptionFulfillment.new(purchase, user).remove
    update_column(:deactivated_on, Time.zone.today)
  end

  def change_plan(new_plan)
    stripe_customer.update_subscription(plan: new_plan.sku)
    self.plan = new_plan
    save!
  end

  def deliver_welcome_email
    if includes_mentor?
      SubscriptionMailer.welcome_to_prime_from_mentor(user).deliver
    end
  end

  def purchase
    user.purchases.for_purchaseable(plan).first
  end

  def team?
    team.present?
  end

  def last_charge
    Stripe::Charge.all(count: 1, customer: stripe_customer_id).first
  end

  private

  def self.canceled_within_period(start_time, end_time)
    where(deactivated_on: start_time...end_time)
  end

  def self.active
    where(deactivated_on: nil)
  end

  def self.recent
    where('created_at > ?', 24.hours.ago)
  end

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end
end
