module WistiaHelper
  def wistia_video_embed(video, size = :large)
    content_tag(
      :iframe,
      '',
      allowtransparency: true,
      frameborder: 0,
      scrolling: 'no',
      class: 'wistia_embed',
      name: 'wistia_embed',
      width: Clip::SIZES[size][:width],
      height: Clip::SIZES[size][:height],
      src: video.embed_url(size)
    )
  end
end
