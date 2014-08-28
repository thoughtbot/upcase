module HtmlHelper
  def truncate_html(html_content)
    html_content = strip_tags html_content
    html_content = html_content.sub(/([.?]).*/m, "\\1")
    truncate(html_content, length: 80, separator: " ")
  end
end
