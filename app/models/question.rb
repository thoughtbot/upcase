class Question < ActiveRecord::Base
  validates :prompt, presence: true
  validates :answer, presence: true

  belongs_to :quiz

  acts_as_list scope: :quiz

  def next
    lower_item
  end
end
