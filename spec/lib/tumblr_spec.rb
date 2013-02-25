require 'spec_helper'
require 'json'
require 'typhoeus'
require 'tumblr'


describe Tumblr, '::recent' do
  before(:all) { stub_typhoeus }

  it 'returns the posts from tumblr' do
    posts = Tumblr.recent

    expect(posts.first[:title]).to eq(tumblr_post[:title])
    expect(posts.first[:body_html]).to eq(tumblr_post[:body])
    expect(posts.first[:tumblr_url]).to eq(tumblr_post[:post_url])
    expect(posts.first[:published_at]).to eq(Time.at tumblr_post[:timestamp])
    expect(posts.first[:tags]).to eq(tumblr_post[:tags])
  end
end

describe Tumblr, '::all' do
  before(:all) { stub_typhoeus(21) }
end

def stub_typhoeus(post_count = 1)
  Typhoeus::Request.stubs(get: stub(body: fake_tumblr(post_count).to_json))
end

def fake_tumblr(post_count)
  {
    response: {
      blog: { posts: 1 },
      posts: [tumblr_post] * post_count,
    }
  }
end

def tumblr_post
  {
    title: 'Milky Dog',
    body: '<p>Milky dog was inspired.</p>',
    post_url: 'http://citriccomics.tumblr.com/post/3507845453',
    timestamp: 1298665620,
    tags: ['tumblrize', 'milky dog', 'mini comic'],
  }
end
