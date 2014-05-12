class Clip
  WISTIA_EMBED_BASE_URL = 'https://fast.wistia.com/embed/iframe/'
  WISTIA_DOWNLOAD_BASE_URL = 'http://thoughtbotlearn.wistia.com/medias/'
  SIZES = {
    large: { width: 653, height: 367 }.freeze,
    small: { width: 563, height: 317 }.freeze,
  }.freeze

  SCREENCASTS_PROMO_ID = 'nuhokhnb7s'
  WEEKLY_ITERATION_PROMO_ID = 'ol6e0miehm'
  WORKSHOPS_PROMO_ID = 'im3s3en4yu'

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

  def embed_url(size)
    WISTIA_EMBED_BASE_URL + hash_id + '?' + embed_params(size)
  end

  def download_url(type)
    WISTIA_DOWNLOAD_BASE_URL + @wistia_id + '/download?asset=' + type
  end

  def thumbnail
    wistia_hash['thumbnail']['url']
  end

  def full_sized_thumbnail
    thumbnail.try(:split, '?').try(:first)
  end

  def running_time
    wistia_hash['duration']
  end

  def sizes
    wistia_hash['assets'].inject({}) do |result, asset|
      result.merge(asset['type'] => human_file_size(asset['fileSize']))
    end
  end

  def to_partial_path
    'clips/clip'
  end

  private

  def wistia_hash
    @wistia_hash ||= Wistia.get_media_hash_from_id(@wistia_id)
  end

  def hash_id
    wistia_hash['hashed_id']
  end

  def embed_params(size)
    dimensions = SIZES[size]

    Rack::Utils.build_query(
      videoWidth: dimensions[:width],
      videoHeight: dimensions[:height],
      controlsVisibleOnLoad: true
    )
  end

  def human_file_size(size)
    number_formatter.number_to_human_size(size)
  end

  def number_formatter
    Object.new.extend(ActionView::Helpers::NumberHelper)
  end
end
