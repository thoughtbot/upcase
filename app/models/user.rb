class User < ApplicationRecord
  include Clearance::User

  has_many :attempts, dependent: :destroy
  has_many :statuses, dependent: :destroy
  belongs_to :team, optional: true

  validates :name, presence: true
  validates :github_username, uniqueness: true, presence: true

  before_save :clean_github_username
  after_save :convert_to_team, if: :new_team_name_given?

  attr_accessor :team_name

  def new_team_name_given?
    team_name.present? && team.nil?
  end

  def convert_to_team
    transaction do
      team = Team.create!(name: team_name, owner: self)
      reload
      update!(team: team)
    end
  end

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(' ').drop(1).join(' ')
  end

  def external_auth?
    auth_provider.present?
  end

  def has_access_to?(feature)
    true
  end

  def has_completed_trails?
    statuses.by_type("Trail").completed.any?
  end

  private

  def clean_github_username
    if github_username.blank?
      self.github_username = nil
    end
  end

  def password_optional?
    super || external_auth?
  end
end
