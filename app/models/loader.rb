class Loader
  def self.import_articles_and_topics(posts)
    posts.each do |post|
      article = Article.find_or_initialize_by_title_and_published_on(post[:title],post[:published_at])
      article.body_html = post[:body_html]
      article.tumblr_url = post[:tumblr_url]
      article.published_on = post[:published_at]
      article.save!
      post[:tags].each do |tag|
        topic = Topic.find_or_create_by_name(tag.downcase)
        article.topics << topic unless article.topics.include?(topic)
      end
    end
  end
end
