class Question < ActiveRecord::Base
  belongs_to :course
  validates :question, presence: true
  validates :answer, presence: true
end
