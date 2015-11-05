class TopicWithTrails < SimpleDelegator
  def initialize(topic_slug:, user:)
    @topic = Topic.find_by!(slug: topic_slug)
    @user = user
    @status_finder = StatusFinder.new(user: @user)
    super(@topic)
  end

  def published_trails
    TrailWithProgressQuery.new(@topic.published_trails, user: @user).to_a
  end
end
