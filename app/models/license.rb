class License < ActiveRecord::Base
  NULL_LICENSE = NullLicense.new

  belongs_to :plan, polymorphic: true
  delegate :annual_plan_id, to: :plan

  def self.for(user)
    if user.present?
      find_by(user_id: user.id) || NULL_LICENSE
    else
      NULL_LICENSE
    end
  end

  def owned_by?(user)
    owner_id == user.id
  end

  def active?
    true
  end

  def eligible_for_annual_upgrade?
    annual_plan_id.present?
  end

  def grants_access_to?(feature)
    plan.public_send("includes_#{feature}")
  end

  private

  def read_only?
    true
  end
end
