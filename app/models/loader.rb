class Loader
  def self.import_articles_and_topics(posts)
    posts.each do |post|
      next if contains_blacklist_topic(post[:tags])
      article = Article.find_or_initialize_by(title: post[:title], published_on: post[:published_at])
      unless article.persisted?
        article.body_html = post[:body_html]
        article.external_url = post[:tumblr_url]
        article.save!
        post[:tags].each do |tag|
          topic = Topic.find_by_slug(tag.downcase.parameterize)
          if topic.nil?
            topic = Topic.new
            topic.name = tag.downcase
            topic.save!
          end
          article.topics << topic unless article.topics.include?(topic)
        end
      end
    end
  end

  private

  def self.contains_blacklist_topic topics
    (topics & BLACKLIST_TOPICS).present?
  end
end
