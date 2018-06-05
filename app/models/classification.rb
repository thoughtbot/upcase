class Classification < ApplicationRecord
  belongs_to :classifiable, polymorphic: true
  belongs_to :topic

  validates :classifiable_id, :uniqueness => { :scope=> [:topic_id, :classifiable_type] }
end
