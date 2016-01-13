require "rails_helper"

describe "twitter_player_cards/_meta.html.erb" do
  it "renders Twitter Player Card meta tags" do
    name = "1986 NBA Finals"
    description = "Bird steals the ball! Underneath to DJ and he lays it in!!!"
    wistia_id = "abc123"
    view_stub_with_return(video_description: description)
    video = create(
      :video,
      name: name,
      wistia_id: wistia_id
    )

    render "twitter_player_cards/meta", video: video

    {
      "card" => "player",
      "site" => "@upcase",
      "title" => name,
      "description" => description,
      "image" => "http://test.host/assets/twitter-card",
      "player" => "http://test.host/videos/1986-nba-finals/twitter_player_card",
      "player:width" => "490",
      "player:height" => "276",
      "player:stream" => "https://thoughtbotlearn.wistia.com/medias/#{wistia_id}",
      "player:stream:content_type" => "video/mp4",
    }.each do |key, content|
      expect(rendered).
        to have_css(twitter_meta_tag(key, content), visible: false)
    end
  end

  def twitter_meta_tag(key, content)
    "meta[name='twitter:#{key}'][content^='#{content}']"
  end
end
