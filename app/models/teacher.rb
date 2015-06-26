class Teacher < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :name, :email, :bio, to: :user, allow_nil: true

  def to_s
    "Teacher: #{name}"
  end
end
