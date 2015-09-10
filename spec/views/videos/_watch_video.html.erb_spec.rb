require "rails_helper"

describe 'videos/_watch_video.html.erb' do
  it "includes a video's notes as html" do
    video = build_stubbed(:video, wistia_id: "123", notes: "### Some notes")

    render_view(video)

    expect(rendered).to have_css "h3", text: "Some notes"
  end

  it "can still render a video without notes" do
    video = build_stubbed(:video, wistia_id: "123")

    expect { render_view(video) }.to_not raise_error
  end

  def have_complete_button
    have_css(".mark-as-complete")
  end

  def render_view(video)
    render 'videos/watch_video', video: video
  end
end
