require 'spec_helper'

describe Loader do
  describe '.save_articles' do
    before do
      @posts = [{
        title: 'whacky article title',
        body_html: '<p>some text here</p>',
        tumblr_url: 'http://robots.thoughtbot.com/whacky-article-title',
        tags: ['ruby', 'ruby on rails', 'cucumber', 'Ruby'],
        published_at: Date.today
      }]
    end

    it 'saves array of articles' do
      Loader.import_articles_and_topics(@posts)

      Article.all.count.should == 1
      Topic.all.count.should == 3
      Article.first.topics.count.should == 3
    end
  end
end
