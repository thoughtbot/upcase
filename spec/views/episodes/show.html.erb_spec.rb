require 'spec_helper'

describe 'episodes/show' do
  it 'embeds a preview when available' do
    video = build(
      :video,
      :published,
      watchable: build_stubbed(:show),
      preview_wistia_id: '123456'
    )

    preview_video = Clip.new('123456')
    preview_video.stubs(:embed_url).returns('http://example.com/medias/xyz890')
    video.stubs(:preview).returns(preview_video)
    stub_controller(video)

    render template: 'episodes/show'

    expect(rendered).to have_css("iframe[src*='xyz890']")
  end

  it 'shows a thumbnail when there is no preview' do
    video = build(
      :video,
      :published,
      watchable: build_stubbed(:show),
      preview_wistia_id: nil
    )

    thumbnail = VideoThumbnail.new('http://embed.wistia.com/some_id')
    video.stubs(:preview).returns(thumbnail)
    stub_controller(video)

    render template: 'episodes/show'

    expect(rendered).to have_css("img[src*='embed.wistia.com']")
  end

  def stub_controller(video)
    assign :plan, double
    assign :video, video

    view_stubs(:signed_out?).returns(true)
  end
end
