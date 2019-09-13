class Repository < Product
  belongs_to :trail, optional: true

  validates :github_repository, presence: true
  validates :github_url, presence: true

  def self.top_level
    where(trail_id: nil)
  end

  private

  def github_client
    Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)
  end
end
