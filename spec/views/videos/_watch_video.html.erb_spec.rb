require "rails_helper"

describe 'videos/_watch_video.html.erb' do
  it "includes a video's notes as html" do
    video = Video.new(wistia_id: '123', notes: "### Some notes")

    render_view(video)

    expect(rendered).to have_css "h3", text: "Some notes"
  end

  it "can still render a video without notes" do
    video = Video.new(wistia_id: '123')

    expect { render_view(video) }.to_not raise_error
  end

  context "for a trail video" do
    it "displays a 'Mark as Complete' button" do
      video = build_video(part_of_trail: true)

      render_view(video)

      expect(rendered).to have_complete_button
    end
  end

  context "for a show video" do
    it "does not display a 'Mark as Complete' button" do
      video = build_video(part_of_trail: false)

      render_view(video)

      expect(rendered).not_to have_complete_button
    end
  end

  def build_video(part_of_trail:)
    build_stubbed(:video).tap do |video|
      allow(video).to receive(:part_of_trail?).and_return(part_of_trail)
    end
  end

  def have_complete_button
    have_css(".mark-as-complete")
  end

  def render_view(video)
    render 'videos/watch_video', video: video
  end
end
