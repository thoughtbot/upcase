class Status < ActiveRecord::Base
  NOT_STARTED = "Not Started"
  STARTED = "Started"
  PUSHED = "Pushed"
  SUBMITTED = "Submitted"
  REVIEWED = "Reviewed"
  NEXT_UP = "Next Up"

  STATES = [STARTED, PUSHED, SUBMITTED, REVIEWED]

  belongs_to :exercise
  belongs_to :user

  validates :exercise_id, :user_id, presence: true
  validates :state, inclusion: { in: STATES }

  def self.most_recent
    order(:created_at).last
  end
end
