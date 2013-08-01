class Note < ActiveRecord::Base
  belongs_to :user

  validates :body, presence: true
  validates :user_id, presence: true
end
