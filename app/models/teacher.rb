class Teacher < ActiveRecord::Base
  belongs_to :user
  belongs_to :video_tutorial

  delegate :name, :email, :bio, to: :user, allow_nil: true
end
