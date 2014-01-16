class Teacher < ActiveRecord::Base
  belongs_to :user
  belongs_to :workshop

  delegate :name, :email, :bio, to: :user
end
