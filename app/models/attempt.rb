class Attempt < ActiveRecord::Base
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :confidence, presence: true

  belongs_to :question
  belongs_to :user
end
