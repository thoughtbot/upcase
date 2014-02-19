class AnalyticsUpdater
  include AnalyticsHelper

  def initialize(user)
    @user = user
  end

  def unsubscribe
    return unless analytics?
    initialize_analytics
    AnalyticsRuby.identify(
      user_id: user_id,
      traits: {
        has_active_subscription: false
      }.merge(intercom_hash(user))
    )
  end

  private

  attr_reader :user

  def initialize_analytics
    AnalyticsRuby.init(secret: ENV['SEGMENT_KEY'])
  end

  def user_id
    user.id.to_s
  end
end
