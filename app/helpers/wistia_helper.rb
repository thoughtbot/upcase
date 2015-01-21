module WistiaHelper
  def large_wistia_iframe_for(clip)
    content_tag(
      'p',
      nil,
      class: "wistia-video",
      data: {
        wistia_id: clip.wistia_id,
        width: "653",
        height: "391"
      }
    )
  end

  def large_wistia_thumbnail_for(thumbnail, title)
    thumbnail(thumbnail, title, 960, 540)
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
