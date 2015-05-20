class Quiz < ActiveRecord::Base
  validates :title, presence: true

  has_many :questions, -> { order(position: :asc) }, dependent: :destroy

  def self.with_questions
    all.select { |quiz| quiz.questions.any? }
  end

  def first_question
    questions.first
  end

  def length
    questions.count
  end
end
