module SearchesHelper
  def cleaned_search_excerpt(highlight)
    highlight.gsub(/([-=|`])+/, '\1').html_safe
  end
end
