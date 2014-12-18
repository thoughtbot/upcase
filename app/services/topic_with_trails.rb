class TopicWithTrails < SimpleDelegator
  def initialize(topic_slug:, user:)
    @topic = Topic.find_by!(slug: topic_slug)
    @user = user
    super(@topic)
  end

  def published_trails
    @topic.published_trails.map do |trail|
      TrailWithProgress.new(trail, user: @user)
    end
  end
end
