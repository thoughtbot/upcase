# This class represents a user's subscription to Learn content
class Subscription < ActiveRecord::Base
  belongs_to :user
  delegate :stripe_customer_id, to: :user

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
    update_column(:deactivated_on, Date.today)
  end

  private

  def deactivate_subscription_purchases
    user.subscription_purchases.each do |purchase|
      purchase.refund
    end
  end

  def self.subscriber_emails
    joins(:user).pluck(:email)
  end

  def self.recent
    where('created_at > ?', 24.hours.ago)
  end
end
