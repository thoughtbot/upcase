class Mentor < ActiveRecord::Base
  NUMBER_OF_MENTORS_TO_PROMOTE = 2

  belongs_to :user
  has_many :mentees, class_name: 'User', foreign_key: 'mentor_id'

  validates :user, presence: true

  delegate :name, :first_name, :email, :github_username, :bio, to: :user

  def self.promoted
    accepting_new_mentees.sample(NUMBER_OF_MENTORS_TO_PROMOTE)
  end

  def self.random
    accepting_new_mentees.sample
  end

  def active_mentees
    mentees
      .with_active_subscription
      .select(&:has_subscription_with_mentor?)
  end

  def active_mentee_count
    active_mentees.count
  end

  def to_s
    "Mentor ##{id}"
  end

  private

  def self.accepting_new_mentees
    where(accepting_new_mentees: true)
  end
end
