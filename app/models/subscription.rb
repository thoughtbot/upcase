# This class represents a user's subscription to Learn content
class Subscription < ActiveRecord::Base
  MAILING_LIST = 'Active Subscribers'
  DOWNGRADED_PLAN = 'prime-maintain'

  belongs_to :user
  belongs_to :mentor, class_name: User
  belongs_to :plan

  delegate :includes_mentor?, to: :plan
  delegate :includes_workshops?, to: :plan
  delegate :stripe_customer_id, to: :user

  validates :mentor_id, presence: true

  after_create :add_user_to_mailing_list

  def self.deliver_welcome_emails
    recent.each do |subscription|
      subscription.deliver_welcome_email
    end
  end

  def self.deliver_byte_notifications
    notifier = ByteNotifier.new(subscriber_emails)
    notifier.send_notifications
  end

  def self.paid
    where(paid: true)
  end

  def active?
    deactivated_on.nil?
  end

  def deactivate
    deactivate_subscription_purchases
    remove_user_from_mailing_list
    update_column(:deactivated_on, Time.zone.today)
  end

  def downgrade
    stripe_customer.update_subscription(plan: downgraded_plan.sku)
    self.plan = downgraded_plan
    save!
  end

  def downgraded?
    plan == downgraded_plan
  end

  def deliver_welcome_email
    if includes_mentor?
      SubscriptionMailer.welcome_to_prime_from_mentor(user).deliver
    else
      SubscriptionMailer.welcome_to_prime(user).deliver
    end
  end

  private

  def downgraded_plan
    Plan.where(sku: Subscription::DOWNGRADED_PLAN).first
  end

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end

  def self.subscriber_emails
    active.joins(:user).pluck(:email)
  end

  def self.active
    where(deactivated_on: nil)
  end

  def self.recent
    where('created_at > ?', 24.hours.ago)
  end

  def deactivate_subscription_purchases
    user.subscription_purchases.each do |purchase|
      purchase.refund
    end
  end

  def add_user_to_mailing_list
    MailchimpFulfillmentJob.enqueue(MAILING_LIST, user.email)
  end

  def remove_user_from_mailing_list
    MailchimpRemovalJob.enqueue(MAILING_LIST, user.email)
  end
end
