class Repository < Product
  belongs_to :trail, optional: true

  validates :github_repository, presence: true
  validates :github_url, presence: true

  def self.top_level
    where(trail_id: nil)
  end
end
