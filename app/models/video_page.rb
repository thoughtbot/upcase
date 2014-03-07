class VideoPage
  attr_reader :purchase, :video

  def initialize(options)
    @purchase = options[:purchase]
    @video = options[:video]
  end

  def purchaseable
    purchase.purchaseable
  end

  def collection?
    purchaseable.collection?
  end

  def name
    purchaseable.name
  end

  def to_aside_partial
    purchaseable.to_aside_partial
  end

  def paid?
    purchase.paid?
  end

  def video_title
    video.title
  end
end
