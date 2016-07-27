class RecommendableContent < ActiveRecord::Base
  acts_as_list

  belongs_to :recommendable, polymorphic: true

  validates :position, presence: true, uniqueness: true

  def self.in_order
    order(position: :asc)
  end
end
