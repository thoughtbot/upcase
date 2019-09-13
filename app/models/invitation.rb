class Invitation < ApplicationRecord
  extend FriendlyId

  validates :email, presence: true
  validates :sender_id, presence: true
  validates :team_id, presence: true

  belongs_to :recipient, class_name: "User", optional: true
  belongs_to :sender, class_name: "User"
  belongs_to :team

  delegate :name, to: :recipient, prefix: true, allow_nil: true
  delegate :name, to: :team, prefix: true

  before_create :generate_code

  friendly_id :code, use: [:finders]

  def self.pending
    where(accepted_at: nil)
  end

  def deliver
    if save
      InvitationMailer.delay.invitation(id)
      true
    else
      false
    end
  end

  def accept(user)
    unless accepted?
      transaction do
        update! accepted_at: Time.current, recipient: user
        team.add_user(user)
      end
    end
  end

  def accepted?
    accepted_at.present?
  end

  def sender_name
    sender.name
  end

  private

  def generate_code
    self.code = SecureRandom.hex(16)
  end
end
