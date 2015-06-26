class Classification < ActiveRecord::Base
  belongs_to :classifiable, polymorphic: true
  belongs_to :topic

  validates :classifiable_id, :uniqueness => { :scope=> [:topic_id, :classifiable_type] }

  def to_s
    "#{topic}/#{classifiable}"
  end
end
