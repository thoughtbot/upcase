class User < ActiveRecord::Base
  include Clearance::User

  has_many :attempts, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :mentor
  belongs_to :team

  validates :name, presence: true
  validates :mentor_id, presence: true, if: :has_subscription_with_mentor?
  validates :github_username, uniqueness: true, presence: true

  delegate :email, to: :mentor, prefix: true, allow_nil: true
  delegate :first_name, to: :mentor, prefix: true, allow_nil: true
  delegate :name, to: :mentor, prefix: true, allow_nil: true
  delegate :plan, to: :subscription, allow_nil: true
  delegate :scheduled_for_deactivation_on, to: :subscription, allow_nil: true

  before_save :clean_github_username

  def self.with_active_subscription
    includes(subscriptions: :plan, team: { subscription: :plan }).
      select(&:has_active_subscription?)
  end

  def self.subscriber_count
    Subscription.active.joins(team: :users).count +
      Subscription.active.includes(:team).where(teams: { id: nil }).count
  end

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(' ').drop(1).join(' ')
  end

  def external_auth?
    auth_provider.present?
  end

  def inactive_subscription
    if has_active_subscription?
      nil
    else
      most_recently_deactivated_subscription
    end
  end

  def create_subscription(plan:, stripe_id:)
    subscriptions.create(plan: plan, stripe_id: stripe_id)
  end

  def has_active_subscription?
    subscription.present?
  end

  def has_access_to?(feature)
    subscription.present? && subscription.has_access_to?(feature)
  end

  def subscribed_at
    subscription.try(:created_at)
  end

  def credit_card
    customer = stripe_customer

    if customer
      customer.cards.detect { |card| card.id == customer.default_card }
    end
  end

  def assign_mentor(mentor)
    update(mentor: mentor)
  end

  def has_subscription_with_mentor?
    has_access_to?(:mentor)
  end

  def plan_name
    plan.try(:name)
  end

  def team_owner?
    team && team.owner?(self)
  end

  def subscription
    [personal_subscription, team_subscription].compact.detect(&:active?)
  end

  def eligible_for_annual_upgrade?
    plan.present? && plan.has_annual_plan?
  end

  def annualized_payment
    plan.annualized_payment
  end

  def discounted_annual_payment
    plan.discounted_annual_payment
  end

  def annual_plan_sku
    plan.annual_plan_sku
  end

  def deactivate_personal_subscription
    if personal_subscription
      Cancellation.new(subscription: personal_subscription).cancel_now
    end
  end

  def has_credit_card?
    stripe_customer_id.present?
  end

  private

  def personal_subscription
    subscriptions.detect(&:active?)
  end

  def clean_github_username
    if github_username.blank?
      self.github_username = nil
    end
  end

  def team_subscription
    if team.present?
      team.subscription
    end
  end

  def stripe_customer
    if stripe_customer_id.present?
      Stripe::Customer.retrieve(stripe_customer_id)
    end
  end

  def password_optional?
    super || external_auth?
  end

  def most_recently_deactivated_subscription
    [*subscriptions, team_subscription].
      compact.
      reject(&:active?).
      max_by(&:deactivated_on)
  end
end
