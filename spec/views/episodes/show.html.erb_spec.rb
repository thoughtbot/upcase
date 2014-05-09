require 'spec_helper'

describe 'episodes/show' do
  it 'embeds a preview when available' do
    video = build(
      :video,
      :published,
      watchable: build_stubbed(:show),
      preview_wistia_id: '123456'
    )

    video.stubs(:preview_video_hash_id).returns('abc789')
    stub_controller(video)

    render template: 'episodes/show'

    expect(rendered).to have_css("iframe[src*='#{video.preview_video_hash_id}']")
  end

  it 'shows a thumbnail when there is no preview' do
    video = build(
      :video,
      :published,
      watchable: build_stubbed(:show),
      preview_wistia_id: nil
    )

    video.
      stubs(:full_sized_wistia_thumbnail).
      returns('http://embed.wistia.com/some_id')
    stub_controller(video)

    render template: 'episodes/show'

    expect(rendered).to have_css("img[src*='embed.wistia.com']")
  end

  def stub_controller(video)
    assign :plan, stub
    assign :video, video
    view.stubs(:signed_out?).returns(true)
  end
end
