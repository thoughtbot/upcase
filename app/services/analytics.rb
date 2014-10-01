class Analytics
  include AnalyticsHelper

  class_attribute :backend
  self.backend = AnalyticsRuby

  def initialize(user)
    @user = user
  end

  def track_cancelled
    track("Cancelled")
  end

  private

  attr_reader :user

  def track(name)
    backend.track(
      event: name,
      user_id: user.id,
      properties: analytics_hash(user),
    )
  end
end
