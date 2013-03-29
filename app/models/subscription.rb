# This class represents a user's subscription to Learn content
class Subscription < ActiveRecord::Base
  belongs_to :user
  delegate :stripe_customer, to: :user

  def self.deliver_welcome_emails
    recent.each do |subscription|
      Mailer.welcome_to_prime(subscription.user).deliver
    end
  end

  private
  def self.recent
    where('created_at > ?', 24.hours.ago)
  end
end
