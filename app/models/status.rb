class Status < ActiveRecord::Base
  UNSTARTED = "Unstarted"
  IN_PROGRESS = "In Progress"
  COMPLETE = "Complete"
  NEXT_UP = "Next Up"

  STATES = [IN_PROGRESS, COMPLETE]

  belongs_to :completeable, polymorphic: true
  belongs_to :user

  validates :completeable_type, :completeable_id, :user_id, presence: true
  validates :state, inclusion: { in: STATES }

  def self.most_recent
    order(:created_at).last
  end

  def self.completed
    where(state: "Complete")
  end

  def self.uncompleted
    where.not(state: "Complete")
  end

  def self.by_user(user)
    where(user: user)
  end

  def self.by_type(type)
    where(completeable_type: type)
  end

  def unstarted?
    false
  end

  def in_progress?
    state == Status::IN_PROGRESS
  end

  def complete?
    state == Status::COMPLETE
  end
end
