class Clip
  WISTIA_DOWNLOAD_BASE_URL = 'http://thoughtbotlearn.wistia.com/medias/'

  attr_reader :wistia_id

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
