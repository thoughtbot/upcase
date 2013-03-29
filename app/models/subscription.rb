# This class represents a user's subscription to Learn content
class Subscription < ActiveRecord::Base
  belongs_to :user
  delegate :stripe_customer, to: :user

  def self.send_welcome_emails
    where('created_at > ?', 24.hours.ago).each do |subscription|
      Mailer.welcome_to_prime(subscription.user).deliver
    end
  end
end
