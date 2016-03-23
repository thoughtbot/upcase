module HtmlHelper
  def truncate_html(raw_content, length: 80)
    html_content = format_markdown(raw_content)
    content = strip_tags(html_content)
    truncate(content, escape: false, length: length, separator: " ").chomp
  end
end
