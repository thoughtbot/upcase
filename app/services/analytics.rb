class Analytics
  include AnalyticsHelper

  class_attribute :backend
  self.backend = AnalyticsRuby

  def initialize(user)
    @user = user
  end

  def track_updated
    backend.identify(user_id: user.id, traits: identify_hash(user))
  end

  def track_status_created(completable, state)
    if completable.is_a? Video
      if state == Status::IN_PROGRESS
        track(
          event: "Started video",
          properties: { video_slug: completable.slug }
        )
      elsif state == Status::COMPLETE
        track(
          event: "Finished video",
          properties: { video_slug: completable.slug }
        )
      end
    end
  end

  def track(event:, properties: {})
    backend.track(
      event: event,
      user_id: user.id,
      properties: properties
    )
  end

  private

  attr_reader :user
end
