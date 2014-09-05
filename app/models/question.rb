class Question < ActiveRecord::Base
  belongs_to :video_tutorial
  validates :question, presence: true
  validates :answer, presence: true
end
