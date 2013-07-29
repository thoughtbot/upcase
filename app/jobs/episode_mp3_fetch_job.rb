class EpisodeMp3FetchJob < Struct.new(:episode_id, :url)
  include ErrorReporting

  PRIORITY = 1

  def self.enqueue(episode_id, url)
    Delayed::Job.enqueue(new(episode_id, url))
  end

  def perform
    episode = Episode.find(episode_id)
    episode.mp3 = URI.parse(url)
    episode.save!
  end
end
