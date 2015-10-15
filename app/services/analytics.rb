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

  def track_video_finished(name:, watchable_name:)
    track("Finished video", name: name, watchable_name: watchable_name)
  end

  def track_video_started(name:, watchable_name:)
    track("Started video", name: name, watchable_name: watchable_name)
    track_touched_video(name: name, watchable_name: watchable_name)
  end

  def track_searched(query:, results_count:)
    track("Searched", query: query, results_count: results_count)
  end

  def track_collaborated(repository_name:)
    track("Created Collaboration", repository_name: repository_name)
  end

  def track_accessed_forum
    track("Logged into Forum")
  end

  def track_cancelled(reason:)
    track("Cancelled", reason: reason, email: user.email)
  end

  def track_flashcard_attempted(deck:, title:)
    track("Flashcard Attempted", deck: deck, title: title)
  end

  def track_downloaded(name:, watchable_name:, download_type:)
    track(
      "Downloaded Video",
      name: name,
      watchable_name: watchable_name,
      download_type: download_type,
    )
    track_touched_video(name: name, watchable_name: watchable_name)
  end

  private

  attr_reader :user

  def track_touched_video(name:, watchable_name:)
    track("Touched Video", name: name, watchable_name: watchable_name)
  end

  def track(event, properties = {})
    backend.track(
      event: event,
      user_id: user.id,
      properties: properties,
    )
  end
end
