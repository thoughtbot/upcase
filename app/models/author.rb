class Author < ActiveRecord::Base
  # Attributes
  attr_accessible :author_id, :email, :first_name, :last_name

  # Associations
  has_many :articles

  # Validations
  validates :tumblr_user_name, presence: true, uniqueness: true
end
