class Analytics
  include AnalyticsHelper

  class_attribute :backend
  self.backend = AnalyticsRuby

  def initialize(user)
    @user = user
  end

  def track_cancelled
    track(event: "Cancelled", properties: {})
  end

  def track_updated
    backend.identify(user_id: user.id, traits: identify_hash(user))
  end

  def track_forum_access
    track(event: "Logged into Forum", properties: {})
  end

  private

  attr_reader :user

  def track(event:, properties:)
    backend.track(
      event: event,
      user_id: user.id,
      properties: properties
    )
  end
end
