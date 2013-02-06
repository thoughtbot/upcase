module ArticlesHelper
  def local_or_external_url(article)
    if article.local?
      article_path(article)
    else
      article.external_url
    end
  end
end
