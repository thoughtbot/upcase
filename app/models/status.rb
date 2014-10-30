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
end
