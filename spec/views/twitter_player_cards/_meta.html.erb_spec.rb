require "rails_helper"

describe "twitter_player_cards/_meta.html.erb" do
  it "renders Twitter Player Card meta tags" do
    title = "1986 NBA Finals"
    description = "Bird steals the ball! Underneath to DJ and he lays it in!!!"
    wistia_id = "abc123"
    view_stubs(video_description: description)
    video = create(
      :video,
      title: title,
      wistia_id: wistia_id
    )

    render "twitter_player_cards/meta", video: video

    {
      "card" => "player",
      "site" => "@upcase",
      "title" => title,
      "description" => description,
      "image" => "http://test.host/assets/twitter-card.png",
      "player" => "http://test.host/videos/1986-nba-finals/twitter_player_card",
      "player:width" => "490",
      "player:height" => "276",
      "player:stream" => "https://thoughtbotlearn.wistia.com/medias/#{wistia_id}",
      "player:stream:content_type" => "video/mp4",
    }.each do |name, content|
      expect(rendered).
        to have_css("meta[name='twitter:#{name}'][content='#{content}']")
    end
  end
end
