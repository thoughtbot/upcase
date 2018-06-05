class Teacher < ApplicationRecord
  belongs_to :user
  belongs_to :video

  delegate :name, :email, :bio, to: :user, allow_nil: true
end
