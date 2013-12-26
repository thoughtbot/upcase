class Mentor < ActiveRecord::Base
  NUMBER_OF_MENTORS_TO_FEATURE = 2

  belongs_to :user
  has_many :mentees, class_name: 'User', foreign_key: 'mentor_id'

  delegate :name, :first_name, :email, :github_username, :bio, to: :user

  def self.featured
    all.sample(NUMBER_OF_MENTORS_TO_FEATURE)
  end

  def self.find_or_sample(mentor_id)
    where(id: mentor_id).first || all.sample
  end

  def active_mentees
    mentees.select do |mentee|
      mentee.has_active_subscription? && mentee.has_subscription_with_mentor?
    end
  end

  def active_mentee_count
    active_mentees.count
  end
end
