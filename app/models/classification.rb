class Classification < ApplicationRecord
  belongs_to :classifiable, polymorphic: true
  belongs_to :topic

  validates :topic_id, :uniqueness => { :scope=> [:classifiable_id, :classifiable_type] }
end
