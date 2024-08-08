class LandingPageTopics
  include Rails.application.routes.url_helpers

  LandingTopic = Struct.new(:name, :slug, :image, :target)

  def topics
    [
      ["Clean Code", "clean-code", "clean-code", topic_path("clean-code")],
      ["Git", "git", "workflow", video_path("git-workflow")],
      ["Ruby on Rails", "rails", "rails", topic_path("rails")],
      ["Testing", "testing", "testing", topic_path("testing")],
      ["iOS", "ios", "ios", topic_path("ios")],
      ["Haskell", "haskell", "haskell", topic_path("haskell")],
      ["JavaScript", "javascript", "javascript", topic_path("javascript")],
      ["Vim", "vim", "vim", topic_path("vim")],
      ["tmux", "tmux", "workflow", trail_path("tmux")],
      ["Design", "design", "design", topic_path("design")]
    ].map { |topic_details| LandingTopic.new(*topic_details) }
  end
end
