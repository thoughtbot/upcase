class License < ActiveRecord::Base
  belongs_to :user
  belongs_to :licenseable, polymorphic: true

  validates :user_id, presence: true

  after_save :fulfill

  delegate :email, :name, to: :user, prefix: true
  delegate :github_username, to: :user
  delegate :name, to: :licenseable, prefix: true

  # Returns an array because licenseable_type is always `Product` in the DB (and
  # querying through Arel)
  def self.for_type(type)
    all.select { |license| license.licenseable.type == type }
  end

  private

  def fulfill
    licenseable.fulfill(user)
  end
end
