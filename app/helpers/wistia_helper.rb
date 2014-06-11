module WistiaHelper
  def large_wistia_iframe_for(clip)
    content_tag(
      'p',
      nil,
      class: "videowrapper wistia-video",
      data: {
        wistia_id: clip.wistia_id,
        width: "653",
        height: "367"
      }
    )
  end

  def small_wistia_iframe_for(clip)
    content_tag(
      'figure',
      nil,
      class: "wistia-video",
      data: {
        wistia_id: clip.wistia_id,
        width: "563",
        height: "317"
      }
    )
  end

  def large_wistia_thumbnail_for(thumbnail, title)
    thumbnail(thumbnail, title, 960, 540)
  end

  def small_wistia_thumbnail_for(thumbnail, title)
    thumbnail(thumbnail, title, 100, 60)
  end

  private

  def thumbnail(thumbnail, title, width, height)
    image_tag(
      '',
      width: width,
      height: height,
      alt: title,
      class: 'thumbnail wistia-thumbnail',
      data: { wistia_id: thumbnail.wistia_id }
    )
  end
end
