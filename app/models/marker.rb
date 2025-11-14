class Marker < ApplicationRecord
  belongs_to :video

  validates :anchor, presence: true
  validates :time, presence: true

  def as_json(*)
    super({only: [:anchor, :time]})
  end
end
