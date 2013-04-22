require 'spec_helper'

describe 'videos/_watch_video.html.erb' do
  it "includes a video's notes as html" do
    video = build_stubbed(:video, notes: 'Some notes')

    render_view(video)

    rendered.should include(video.notes_html)
  end

  it "can still render a video without notes" do
    video = build_stubbed(:video)

    expect { render_view(video) }.to_not raise_error
  end

  def render_view(video)
    purchaseable = build_stubbed(:video_product)

    render 'videos/watch_video', video: video, purchaseable: purchaseable
  end
end
