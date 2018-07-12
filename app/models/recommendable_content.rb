class RecommendableContent < ApplicationRecord
  acts_as_list

  belongs_to :recommendable, polymorphic: true

  validates :position, uniqueness: true

  def self.priority_ordered
    order(position: :asc)
  end
end
