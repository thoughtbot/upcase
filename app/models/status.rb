class Status < ActiveRecord::Base
  STATES = %w(Started Pushed Submitted Reviewed)

  belongs_to :exercise
  belongs_to :user

  validates :exercise_id, :user_id, presence: true
  validates :state, inclusion: { in: STATES }

  def self.most_recent
    order(:created_at).last
  end
end
