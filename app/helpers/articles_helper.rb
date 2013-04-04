module ArticlesHelper
  def byte_or_external_url(article)
    if article.byte?
      article_path(article)
    else
      article.external_url
    end
  end
end
