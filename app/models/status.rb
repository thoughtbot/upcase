class Status < ApplicationRecord
  UNSTARTED = "Unstarted"
  IN_PROGRESS = "In Progress"
  COMPLETE = "Complete"
  NEXT_UP = "Next Up"

  STATES = [IN_PROGRESS, COMPLETE]

  belongs_to :completeable, polymorphic: true, touch: true
  belongs_to :user

  validates :completeable_type, :completeable_id, :user_id, presence: true
  validates :state, inclusion: { in: STATES }

  def self.most_recent
    order(:created_at).last
  end

  def self.completed
    where(state: COMPLETE)
  end

  def self.by_user(user)
    where(user: user)
  end

  def self.by_type(type)
    where(completeable_type: type)
  end

  def self.active
    where(state: [UNSTARTED, IN_PROGRESS])
  end

  def self.most_recent_for_user(user)
    by_user(user).most_recent || Unstarted.new
  end

  def unstarted?
    false
  end

  def in_progress?
    state == IN_PROGRESS
  end

  def complete?
    state == COMPLETE
  end
end
