class Marker < ActiveRecord::Base
  belongs_to :video

  validates :anchor, presence: true
  validates :time, presence: true

  def as_json(_options)
    super(only: [:anchor, :time])
  end
end
