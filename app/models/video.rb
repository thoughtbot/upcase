class Video < ActiveRecord::Base
  attr_accessor :wistia_hash, :video_sizes, :video_hash_id

  belongs_to :product

  validates_presence_of :product_id, :wistia_id

  def video_sizes
    @video_sizes ||= JSON.parse(wistia_hash)["assets"].inject({}){|result, asset| result.merge(asset["type"]=>human_file_size(asset['fileSize']))}
  rescue
    {}
  end

  def video_hash_id
    @video_hash_id ||= JSON.parse(wistia_hash)["hashed_id"] rescue nil
  end

  def wistia_hash
    @wistia_hash ||= Wistia.get_media_hash_from_id(wistia_id).to_json unless wistia_id.nil?
  end

  def wistia_thumbnail
    @wistia_thumbnail ||= JSON.parse(wistia_hash)["thumbnail"]["url"] rescue nil
  end

  def wistia_running_time
    @wistia_running_time ||= JSON.parse(wistia_hash)["duration"] rescue nil
    Time.at(@wistia_running_time.to_i).gmtime.strftime('%M:%S')
  end

  private

  def human_file_size num
    helpers.number_to_human_size(num)
  end

  def helpers
    ActionController::Base.helpers
  end
end
