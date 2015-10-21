class Collaboration < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user

  validates :user_id, presence: true
  validates :repository_id, presence: true
end
