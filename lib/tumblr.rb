class Tumblr
  def self.recent(tumblr_handle = "thoughtbot",offset = 0)
    response = Typhoeus::Request.get(posts_url(tumblr_handle,offset))
    feed = JSON.parse(response.body)
    normalized_posts feed['response']['posts']
  end

  def self.all(tumblr_handle="thoughtbot")
    all_posts = []
    posts_count = posts_count(tumblr_handle)
    (0..posts_count/20).each do |batch_no|
      all_posts += self.recent(tumblr_handle, batch_no * 20)
      puts all_posts.count
    end
    all_posts
  end

  private
  def self.posts_url(tumblr_handle, offset)
    "http://api.tumblr.com/v2/blog/#{tumblr_handle}.tumblr.com/posts/text?#{api_key_string}&offset=#{offset}"
  end

  def self.posts_count(tumblr_handle)
    tumblr_url = "http://api.tumblr.com/v2/blog/#{tumblr_handle}.tumblr.com/info?#{api_key_string}"
    response = Typhoeus::Request.get(tumblr_url)
    JSON.parse(response.body)['response']['blog']['posts']
  end

  def self.api_key_string
    "api_key=#{ENV['TUMBLR_API_KEY']}"
  end

  def self.normalized_posts posts
    posts.map do |post|
      {
        title: post['title'],
        body_html: post['body'],
        tumblr_url: post['post_url'],
        published_at: Time.at(post['timestamp']),
        tags: post['tags']
      }
    end
  end
end
