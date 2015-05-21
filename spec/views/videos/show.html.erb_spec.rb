require "rails_helper"

describe "videos/show" do
  it "embeds a preview when available" do
    video = create(
      :video,
      :published,
      watchable: create(:show),
      preview_wistia_id: "123456"
    )

    wistia_id = "123"
    preview_video = Clip.new(wistia_id)
    allow(video).to receive(:preview).and_return(preview_video)
    stub_controller(video)

    render template: "videos/show"

    expect(rendered).
      to have_css("p[data-wistia-id='#{wistia_id}']")
  end

  it "shows a thumbnail when there is no preview" do
    video = build(
      :video,
      :published,
      watchable: build_stubbed(:show),
      preview_wistia_id: nil
    )

    wistia_id = "123"
    clip = double("Clip", wistia_id: wistia_id)
    thumbnail = VideoThumbnail.new(clip)
    allow(video).to receive(:preview).and_return(thumbnail)
    stub_controller(video)

    render template: "videos/show"

    expect(rendered).to have_css("img.thumbnail[data-wistia-id='#{wistia_id}']")
  end

  def stub_controller(video)
    plan = double("plan", price: 29)
    assign :plan, plan
    assign :video, video
    assign :watchable, video.watchable

    view_stubs(:signed_out?).and_return(true)
    view_stubs(:signed_in?).and_return(false)
    view_stubs(:current_user_has_active_subscription?).and_return(false)
  end
end
