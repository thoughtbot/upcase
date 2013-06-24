# This class represents a user's subscription to Learn content
class Subscription < ActiveRecord::Base
  MAILING_LIST = 'Active Subscribers'

  belongs_to :user
  delegate :stripe_customer_id, to: :user

  after_create :add_user_to_mailing_list

  def self.deliver_welcome_emails
    recent.each do |subscription|
      Mailer.welcome_to_prime(subscription.user).deliver
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

  private

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
