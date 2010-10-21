class FollowUp < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :email
end
