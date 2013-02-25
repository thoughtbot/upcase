require 'spec_helper'

describe Tumblr, '::recent' do

  it 'returns the posts from tumblr' do
    stub_typhoeus

    posts = Tumblr.recent

    expect(posts.first[:title]).to eq(tumblr_post[:title])
    expect(posts.first[:body_html]).to eq(tumblr_post[:body])
    expect(posts.first[:tumblr_url]).to eq(tumblr_post[:post_url])
    expect(posts.first[:published_at]).to eq(Time.at tumblr_post[:timestamp])
    expect(posts.first[:tags]).to eq(tumblr_post[:tags])
  end

  def stub_typhoeus
    Typhoeus::Request.stubs(get: stub(body: fake_tumblr.to_json))
  end

  def fake_tumblr
    {
      response: {
        blog: { posts: 1 },
        posts: [tumblr_post],
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
end
