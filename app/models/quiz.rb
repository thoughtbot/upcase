class Quiz < ActiveRecord::Base
  validates :title, presence: true

  has_many :questions, -> { order(position: :asc) }, dependent: :destroy

  def self.published
    where(published: true)
  end

  def first_question
    questions.first
  end

  def length
    questions.count
  end
end
