class Video < ActiveRecord::Base
  attr_accessor :wistia_hash, :video_sizes, :video_hash_id

  belongs_to :purchaseable, polymorphic: true

  validates :purchaseable_id, presence: true
  validates :purchaseable_type, presence: true
  validates :wistia_id, presence: true

  def video_sizes
    @video_sizes ||= wistia_hash["assets"].inject({}){|result, asset| result.merge(asset["type"]=>human_file_size(asset['fileSize']))}
  rescue
    {}
  end

  def video_hash_id
    @video_hash_id ||= wistia_hash["hashed_id"] rescue nil
  end

  def wistia_hash
    @wistia_hash ||= Wistia.get_media_hash_from_id(wistia_id) unless wistia_id.nil?
  end

  def wistia_running_time
    @wistia_running_time ||= wistia_hash["duration"] rescue nil
    Time.at(@wistia_running_time.to_i).gmtime.strftime('%M:%S')
  end

  def wistia_thumbnail
    @wistia_thumbnail ||= wistia_hash["thumbnail"]["url"] rescue nil
  end

  private

  def human_file_size num
    helpers.number_to_human_size(num)
  end

  def helpers
    ActionController::Base.helpers
  end
end
