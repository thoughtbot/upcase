class License < ActiveRecord::Base
  belongs_to :user
  belongs_to :licenseable, polymorphic: true

  validates :user_id, presence: true

  after_save :fulfill

  delegate :email, to: :user, prefix: true
  delegate :github_username, to: :user
  delegate :name, to: :licenseable, prefix: true

  def starts_on
    licenseable.starts_on(created_at.to_date)
  end

  def ends_on
    licenseable.ends_on(created_at.to_date)
  end

  def active?
    (starts_on..ends_on).cover?(Time.zone.today)
  end

  def status
    if self.ends_on.today? || self.ends_on.future?
      'in-progress'
    elsif self.ends_on.past?
      'complete'
    end
  end

  private

  def fulfill
    licenseable.fulfill(self, user)
  end
end
