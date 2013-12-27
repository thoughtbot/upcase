class Mentor < ActiveRecord::Base
  NUMBER_OF_MENTORS_TO_FEATURE = 2

  belongs_to :user
  has_many :mentees, class_name: 'User', foreign_key: 'mentor_id'

  delegate :name, :first_name, :email, :github_username, :bio, to: :user

  def self.featured
    accepting_new_mentees.sample(NUMBER_OF_MENTORS_TO_FEATURE)
  end

  def self.find_or_sample(mentor_id)
    where(id: mentor_id).first || accepting_new_mentees.sample
  end

  def active_mentees
    mentees.select do |mentee|
      mentee.has_active_subscription? && mentee.has_subscription_with_mentor?
    end
  end

  def active_mentee_count
    active_mentees.count
  end

  private

  def self.accepting_new_mentees
    where(accepting_new_mentees: true)
  end
end
