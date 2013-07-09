class User < ActiveRecord::Base
  THOUGHTBOT_TEAM_ID = 3675

  include Clearance::User

  attr_accessible :email, :name, :github_username, :password, :auth_provider, :auth_uid

  has_many :paid_purchases, class_name: 'Purchase',
    conditions: { paid: true }
  has_many :purchases
  has_many :completions
  has_one :subscription

  validates :name, presence: true

  after_create :associate_previous_purchases

  def self.find_or_create_from_auth_hash(auth_hash)
    find_by_auth_hash(auth_hash) || create_from_auth_hash(auth_hash)
  end

  def self.find_by_auth_hash(auth_hash)
    where(auth_provider: auth_hash['provider'], auth_uid: auth_hash['uid']).first
  end

  def self.create_from_auth_hash(auth_hash)
    begin
      name = auth_hash['info']['name'] ? auth_hash['info']['name'] : ['GitHub', 'User']
      create(
        auth_provider: auth_hash['provider'],
        auth_uid: auth_hash['uid'],
        name: name,
        email: auth_hash['info']['email'],
        github_username: auth_hash['info']['nickname']
      ).tap { |user| user.promote_thoughtbot_employee_to_admin }
    rescue NoMethodError => e
      Airbrake.notify(
        :error_class   => "Auth hash error",
        :error_message => e.message,
        :parameters    => auth_hash
      )
    end
  end

  def subscription_purchases
    paid_purchases.where(payment_method: 'subscription')
  end

  def promote_thoughtbot_employee_to_admin
    client = Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
    if client.team_member?(THOUGHTBOT_TEAM_ID, github_username)
      self.admin = true
      save!
    end
  end

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(" ").last
  end

  def external_auth?
    auth_provider.present?
  end

  def has_purchased?
    paid_purchases.present?
  end

  def inactive_subscription
    if subscription.present? && !subscription.active?
      subscription
    end
  end

  def has_active_subscription?
    subscription.present? && subscription.active?
  end

  def has_conflict?(desired_purchaseable)
    if desired_purchaseable.is_a?(Section)
      purchases = paid_purchases.where(purchaseable_type: 'Section')

      purchases.any? do |purchase|
        range = purchase.starts_on..purchase.ends_on

        range.cover?(desired_purchaseable.starts_on(Time.zone.today)) ||
          range.cover?(desired_purchaseable.ends_on(Time.zone.today))
      end
    else
      false
    end
  end

  private

  def password_optional?
    super || external_auth?
  end

  def associate_previous_purchases
    previous_purchases = Purchase.by_email(email)
    self.purchases << previous_purchases

    existing_stripe_customer_id = previous_purchases.stripe.last.try(:stripe_customer_id)

    if existing_stripe_customer_id
      self.update_column(:stripe_customer_id, existing_stripe_customer_id)
    end
  end
end
