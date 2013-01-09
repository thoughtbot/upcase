class Question < ActiveRecord::Base
  belongs_to :workshop
  validates :question, presence: true
  validates :answer, presence: true
end
