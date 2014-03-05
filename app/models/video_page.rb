class VideoPage
  attr_reader :purchase, :video

  def initialize(options)
    @purchase = options[:purchase]
    @video = options[:video]
  end

  def purchaseable
    purchase.purchaseable
  end
end
