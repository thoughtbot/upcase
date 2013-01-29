module ArticlesHelper
  def local_or_tumblr_url(article)
    if article.tumblr_url.present?
      article.tumblr_url
    else
      article_path(article)
    end
  end
end
