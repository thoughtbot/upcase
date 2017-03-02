# This class represents a user or team's subscription to Upcase content
class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan, polymorphic: true

  has_one :team, dependent: :destroy

  delegate :name, to: :plan, prefix: true

  validates :plan_id, presence: true
  validates :plan_type, presence: true
  validates :user_id, presence: true

  def self.restarting_today
    where.not(deactivated_on: nil).
      where(
        reactivated_on: nil,
        scheduled_for_reactivation_on: Time.zone.today,
      )
  end

  def self.restarting_in_two_days
    where.not(deactivated_on: nil).
      where(scheduled_for_reactivation_on: Time.zone.today + 2.days)
  end

  def self.canceled_in_last_30_days
    canceled_within_period(30.days.ago, Time.zone.now)
  end

  def self.active_as_of(time)
    where("deactivated_on is null OR deactivated_on > ?", time)
  end

  def self.created_before(time)
    where("created_at <= ?", time)
  end

  def self.next_payment_in_2_days
    where(next_payment_on: 2.days.from_now)
  end

  def active?
    deactivated_on.nil?
  end

  def stripe_customer_id
    if team.present?
      team.owner.stripe_customer_id
    else
      user.stripe_customer_id
    end
  end

  def scheduled_for_deactivation?
    scheduled_for_deactivation_on.present?
  end

  def deactivate
    SubscriptionFulfillment.new(user, plan).remove
    update_column(:deactivated_on, Time.zone.today)
  end

  def reactivate
    update_column(:scheduled_for_deactivation_on, nil)
    reactivate_stripe_subscription_as_per_stripe_docs
  end

  def change_plan(sku:)
    write_plan(sku: sku)
    change_stripe_plan(sku: sku)
  end

  def write_plan(sku:)
    update_features do
      self.plan = Plan.find_by!(sku: sku)
      save!
      track_updated
    end
  end

  def change_stripe_plan(sku:)
    subscription = stripe_customer.subscriptions.first
    subscription.plan = sku
    subscription.save
  end

  def change_quantity(new_quantity)
    subscription = stripe_customer.subscriptions.first
    subscription.plan = plan.sku
    subscription.quantity = new_quantity
    subscription.save
  end

  def team?
    team.present?
  end

  def last_charge
    Stripe::Charge.all(count: 1, customer: stripe_customer_id).first
  end

  def owner?(other_user)
    user == other_user
  end

  def next_payment_amount_in_dollars
    next_payment_amount / 100
  end

  private

  def reactivate_stripe_subscription_as_per_stripe_docs
    stripe_sub = stripe_subscription
    stripe_sub.plan = stripe_sub.plan.id
    stripe_sub.save
  end

  def self.canceled_within_period(start_time, end_time)
    where(deactivated_on: start_time...end_time)
  end

  def self.active
    where(deactivated_on: nil)
  end

  def self.recent
    where('created_at > ?', 24.hours.ago)
  end

  def update_features
    old_plan = plan
    yield
    new_plan = plan
    update_feature_fulfillments(old_plan, new_plan)
  end

  def update_feature_fulfillments(old_plan, new_plan)
    feature_fulfillment = FeatureFulfillment.new(
      new_plan: new_plan,
      old_plan: old_plan,
      user: user
    )
    feature_fulfillment.fulfill_gained_features
    feature_fulfillment.unfulfill_lost_features
  end

  def track_updated
    users_for_analytics_tracking.each do |user|
      Analytics.new(user).track_updated
    end
  end

  def users_for_analytics_tracking
    if team
      team.users
    else
      [user]
    end
  end

  def stripe_customer
    StripeCustomerFinder.retrieve(stripe_customer_id)
  end

  def stripe_subscription
    stripe_customer.subscriptions.retrieve(stripe_id)
  end
end
