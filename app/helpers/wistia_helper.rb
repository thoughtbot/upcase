module WistiaHelper
  def wistia_video_embed(video_hash, width = 653, height = 367)
    content_tag(
      :iframe,
      '',
      allowtransparency: true,
      frameborder: 0,
      scrolling: 'no',
      class: 'wistia_embed',
      name: 'wistia_embed',
      width: width,
      height: height,
      src: wistia_video_url_with_settings(video_hash, width, height)
    )
  end

  private

  def wistia_video_url_with_settings(video_hash, width, height)
    unless Rails.env.test?
      "#{wistia_video_url(video_hash)}?#{wistia_query(width, height)}".html_safe
    end
  end

  def wistia_video_url(video_hash)
    "https://fast.wistia.com/embed/iframe/#{video_hash}"
  end

  def wistia_query(width, height)
    Rack::Utils.build_query(
      videoWidth: width,
      videoHeight: height,
      controlsVisibleOnLoad: true
    )
  end
end
