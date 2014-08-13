class Invitation < ActiveRecord::Base
  extend FriendlyId

  validates :email, presence: true
  validates :sender_id, presence: true
  validates :team_id, presence: true
  validate :limit_invitation_count

  belongs_to :recipient, class_name: 'User'
  belongs_to :sender, class_name: 'User'
  belongs_to :team

  delegate :name, to: :recipient, prefix: true, allow_nil: true

  before_create :generate_code

  friendly_id :code, use: [:finders]

  def deliver
    if save
      InvitationMailer.delay.invitation(id)
      true
    else
      false
    end
  end

  def accept(user)
    transaction do
      update_attributes! accepted_at: Time.now, recipient: user
      team.add_user(user)
    end
  end

  def accepted?
    accepted_at.present?
  end

  def has_users_remaining?
    team.has_users_remaining?
  end

  def sender_name
    sender.name
  end

  private

  def generate_code
    self.code = SecureRandom.hex(16)
  end

  def limit_invitation_count
    if max_users_reached?
      errors.add :team, 'has no users remaining'
    end
  end

  def max_users_reached?
    team.present? && !has_users_remaining?
  end
end
