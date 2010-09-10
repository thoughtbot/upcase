class Registration < ActiveRecord::Base
  belongs_to :section
  belongs_to :user

  validates_associated :user
end
