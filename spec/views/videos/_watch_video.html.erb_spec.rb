require "rails_helper"

describe 'videos/_watch_video.html.erb' do
  it "includes a video's notes as html" do
    video = Video.new(wistia_id: '123', notes: 'Some notes')

    render_view(video)

    expect(rendered).to include(video.notes_html)
  end

  it "can still render a video without notes" do
    video = Video.new(wistia_id: '123')

    expect { render_view(video) }.to_not raise_error
  end

  def render_view(video)
    render 'videos/watch_video', video: video
  end
end
