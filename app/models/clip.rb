class Clip
  WISTIA_DOWNLOAD_BASE_URL = 'http://thoughtbotlearn.wistia.com/medias/'
  SCREENCASTS_PROMO_ID = 'nuhokhnb7s'
  WEEKLY_ITERATION_PROMO_ID = 'ol6e0miehm'
  WORKSHOPS_PROMO_ID = 'im3s3en4yu'

  attr_reader :wistia_id

  def self.screencasts_promo
    new(SCREENCASTS_PROMO_ID)
  end

  def self.weekly_iteration_promo
    new(WEEKLY_ITERATION_PROMO_ID)
  end

  def self.workshops_promo
    new(WORKSHOPS_PROMO_ID)
  end

  def initialize(wistia_id)
    @wistia_id = wistia_id
  end

  def download_url(type)
    WISTIA_DOWNLOAD_BASE_URL + wistia_id + '/download?asset=' + type
  end

  def to_partial_path
    'clips/clip'
  end
end
