require 'open-uri'
require 'nokogiri'

module Playbook
  class Page
    attr_reader :raw_html, :url

    def initialize(url)
      @url = url
      @raw_html = Nokogiri::HTML(request)
    end

    def content
      raw_content = @raw_html.at_css('section#content').clone
      raw_content.search('h1, .breadcrumbs').remove
      raw_content.children.to_s.strip!
    end

    def last_modified
      if request.methods.include?(:meta) && request.meta.key?('last-modified')
        Time.parse(@request.meta['last-modified'])
      else
        Time.now
      end
    end

    def title
      "The Playbook : #{@raw_html.at_css('section#content h1').text}"
    end

    def topics
      keywords.append('playbook').uniq.map do |keyword|
        Topic.find_or_create_by_name(keyword)
      end
    end

    def request
      @request ||= open(@url)
    end

    def save_as_article
      article = Article.find_or_initialize_by_external_url(@url)
      article.body_html    = content
      article.published_on = last_modified
      article.title        = title
      article.topics       = topics

      if article.save
        puts "Saved playbook article '#{article.title}'"
      end
    end

    private

    def keywords
      @raw_html.at_css('meta[name="keywords"]').attribute('content').to_s.
        split(',').map{|topic| topic.downcase.strip }
    end
  end
end
