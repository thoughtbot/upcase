require 'spec_helper'

describe TumblrClient, '.recent' do
  include Rails.application.routes.url_helpers

  it 'returns the posts from tumblr' do
    stub_typhoeus

    posts = TumblrClient.recent

    expect(posts.first[:title]).to eq(tumblr_post[:title])
    expect(posts.first[:body_html]).to eq(tumblr_post[:body])
    expect(posts.first[:tumblr_url]).to eq(tumblr_post[:post_url])
    expect(posts.first[:published_at]).to eq(Time.at tumblr_post[:timestamp])
    expect(posts.first[:tags]).to eq(tumblr_post[:tags])
  end

  it 'posts an episode to tumblr' do
    episode = create(:episode)
    episode.topics << create(:topic, name: 'Rails')
    episode.topics << create(:topic, name: 'Ruby')
    request = stub(perform: nil)
    post = stub(post: request)
    client = stub()
    Tumblr::Post::Link.stubs(:new).returns(post)
    Tumblr::Client.stubs(:new).returns(client)

    tumblr_client = TumblrClient.new
    tumblr_client.post_episode(episode)

    expect(Tumblr::Post::Link).to have_received(:new).with(
      {
        state: 'published',
        tags: 'podcast,rails,ruby',
        format: 'markdown',
        title: "#{episode.show.short_title} Podcast #{episode.full_title}",
        url: show_episode_url(episode.show, episode, host: HOST),
        description: <<-DESCRIPTION
#{episode.description}

* [Episode Notes and Links](#{show_episode_url(episode.show, episode, host: HOST)})
* [Subscribe via iTunes](#{episode.show.itunes_url})
* [Subscribe via RSS](#{show_episodes_url(episode.show, format: :xml, host: HOST)})
* [Direct Download](#{show_episode_url(episode.show, episode, format: :mp3, host: HOST)})
        DESCRIPTION
      }
    )
    expect(post).to have_received(:post).with(client)
    expect(request).to have_received(:perform)
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
