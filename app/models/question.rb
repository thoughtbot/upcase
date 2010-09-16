class Question < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :question, :answer
end
