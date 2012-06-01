require 'spec_helper'

describe Tumblr, '.recent' do
  before do
    VCR.use_cassette('blog_posts') do
      @posts = Tumblr.recent('thoughtbot')
    end
  end

  it 'returns posts from tumblr' do
    @posts.should_not be_empty

    @posts.each do |post|
      post.should have_key(:title)
      post.should have_key(:body_html)
      post.should have_key(:tumblr_url)
      post[:tumblr_url].should match %r{^http://robots\.thoughtbot\.com}
    end
  end
end
