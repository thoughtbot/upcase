class AnalyticsUpdater
  include AnalyticsHelper

  def initialize(user)
    @user = user
  end

  def unsubscribe
    if analytics?
      initialize_analytics
      unsubscribe_analytics
    end
  end

  private

  attr_reader :user

  def initialize_analytics
    AnalyticsRuby.init(secret: ENV['SEGMENT_KEY'])
  end

  def unsubscribe_analytics
    AnalyticsRuby.identify(
      user_id: user_id,
      traits: unsubscribe_traits
    )
  end

  def unsubscribe_traits
    { has_active_subscription: false }.merge(intercom_hash(user))
  end

  def user_id
    user.id.to_s
  end
end
