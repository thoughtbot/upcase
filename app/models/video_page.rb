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

  def paid?
    purchase.paid?
  end

  def title
    video.title
  end
end
