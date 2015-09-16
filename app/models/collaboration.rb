class Collaboration < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user

  def to_s
    "Collaboration ##{id}"
  end
end
