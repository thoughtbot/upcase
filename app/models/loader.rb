class Loader
  def self.import_articles_and_topics(posts)
    posts.each do |post|
      next if post[:tags].include?("this week in open source")
      article = Article.find_or_initialize_by_title_and_published_on(post[:title],post[:published_at])
      unless article.persisted?
        article.body_html = post[:body_html]
        article.tumblr_url = post[:tumblr_url]
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
end
