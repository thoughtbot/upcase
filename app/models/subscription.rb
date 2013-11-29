# This class represents a user's subscription to Learn content
class Subscription < ActiveRecord::Base
  MAILING_LIST = 'Active Subscribers'
  GITHUB_TEAM = 516450

  belongs_to :user
  belongs_to :plan, polymorphic: true
  belongs_to :team

  delegate :includes_mentor?, to: :plan
  delegate :includes_workshops?, to: :plan
  delegate :stripe_customer_id, to: :user

  validates :plan_id, presence: true
  validates :plan_type, presence: true
  validates :user_id, presence: true

  after_create :add_user_to_mailing_list
  after_create :add_user_to_github_team

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

  def active?
    deactivated_on.nil?
  end

  def deactivate
    deactivate_subscription_purchases
    remove_user_from_mailing_list
    remove_user_from_github_team
    update_column(:deactivated_on, Time.zone.today)
  end

  def change_plan(new_plan)
    stripe_customer.update_subscription(plan: new_plan.sku)
    self.plan = new_plan
    save!
  end

  def downgraded?
    plan == IndividualPlan.downgraded
  end

  def deliver_welcome_email
    if includes_mentor?
      SubscriptionMailer.welcome_to_prime_from_mentor(user).deliver
    else
      SubscriptionMailer.welcome_to_prime(user).deliver
    end
  end

  private

  def self.canceled_within_period(start_time, end_time)
    where(deactivated_on: start_time...end_time)
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

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end

  def deactivate_subscription_purchases
    user.subscription_purchases.each do |purchase|
      PurchaseRefunder.new(purchase).refund
    end
  end

  def add_user_to_mailing_list
    MailchimpFulfillmentJob.enqueue(MAILING_LIST, user.email)
  end

  def remove_user_from_mailing_list
    MailchimpRemovalJob.enqueue(MAILING_LIST, user.email)
  end

  def add_user_to_github_team
    GithubFulfillmentJob.enqueue(GITHUB_TEAM, [user.github_username])
  end

  def remove_user_from_github_team
    GithubRemovalJob.enqueue(GITHUB_TEAM, [user.github_username])
  end
end
