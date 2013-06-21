class Video < ActiveRecord::Base
  attr_accessor :wistia_hash, :video_sizes, :video_hash_id

  belongs_to :watchable, polymorphic: true

  validates :watchable_id, presence: true
  validates :watchable_type, presence: true
  validates :wistia_id, presence: true

  delegate :name, to: :watchable, prefix: true

  def self.ordered
    order('active_on_day asc, position asc')
  end

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
    @wistia_running_time ||= wistia_hash["duration"] rescue 0
  end

  def wistia_thumbnail
    @wistia_thumbnail ||= wistia_hash["thumbnail"]["url"] rescue nil
  end

  def available?(start_date)
    available_on(start_date) <= Time.zone.today
  end

  def available_on(start_date)
    start_date + active_on_day.days
  end

  def starts_today?(start_date)
    available_on(start_date) == Time.zone.today
  end

  def has_notes?
    notes.present?
  end

  def notes_html
    BlueCloth.new(notes).to_html
  end

  private

  def human_file_size num
    helpers.number_to_human_size(num)
  end

  def helpers
    ActionController::Base.helpers
  end
end
