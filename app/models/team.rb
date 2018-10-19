# A Team represents a company or other group
class Team < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :invitations
  belongs_to :owner, class_name: "User"

  validates :name, presence: true

  def owner?(user)
    owner.eql?(user)
  end

  def add_user(user)
    user.team = self
    user.save!
  end

  def remove_user(user)
    user.team = nil
    user.save!
  end

  def users_count
    users.count
  end
end
