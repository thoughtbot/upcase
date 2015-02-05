require "rails_helper"

describe "twitter_player_cards/show.html.erb" do
  it "includes a video source" do
    preview_wistia_id = "abc123"
    video = double("video", preview_wistia_id: preview_wistia_id)

    assign :video, video
    render

    expect(rendered)
      .to have_css("source[src='https://thoughtbotlearn.wistia.com/medias/#{preview_wistia_id}/download?asset=hd_mp4']")
  end
end
