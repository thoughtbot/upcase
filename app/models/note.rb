class Note < ActiveRecord::Base
  attr_accessor :timeline_user_id

  belongs_to :user
  belongs_to :contributor, class_name: 'User'

  validates :body, presence: true
  validates :user_id, presence: true
  validates :contributor_id, presence: true

  def body_html
    BlueCloth.new(body).to_html
  end

  def created_by?(user)
    contributor_id == user.id
  end

  def allowed_to_be_edited_by?(user)
    created_by?(user)
  end
end
