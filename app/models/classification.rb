class Classification < ActiveRecord::Base
  attr_accessible :classifiable_id, :classifiable_type, :classifiable, :topic_id
  belongs_to :classifiable, polymorphic: true
  belongs_to :topic
  after_create :update_topic_count

  validates :classifiable_id, :uniqueness => { :scope=> [:topic_id, :classifiable_type] }

  def update_topic_count
    self.topic.count = self.topic.classifications.count
    self.topic.save!
  end
end
