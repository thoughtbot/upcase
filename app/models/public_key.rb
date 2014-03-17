class PublicKey < ActiveRecord::Base
  validates :data, presence: true
  validates :user_id, presence: true
end
