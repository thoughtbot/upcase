class Invitation < ActiveRecord::Base
  extend FriendlyId

  validates :email, presence: true
  validates :sender_id, presence: true
  validates :team_id, presence: true

  belongs_to :recipient, class_name: User
  belongs_to :sender, class_name: User
  belongs_to :team

  delegate :name, to: :recipient, prefix: true, allow_nil: true

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
    transaction do
      update_attributes! accepted_at: Time.now, recipient: user
      team.add_user(user)
    end
  end

  def accepted?
    accepted_at.present?
  end

  def sender_name
    sender.name
  end

  def to_s
    "Invitation for #{email}"
  end

  def user_by_email
    User.find_by(email: email)
  end

  private

  def generate_code
    self.code = SecureRandom.hex(16)
  end
end
