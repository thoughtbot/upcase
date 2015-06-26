class Repository < Product
  belongs_to :trail
  has_many :collaborations, dependent: :destroy

  validates :github_repository, presence: true
  validates :github_url, presence: true

  def self.top_level
    where(trail_id: nil)
  end

  def included_in_plan?(plan)
    plan.has_feature?(:repositories)
  end

  def add_collaborator(user)
    collaborations.create!(user: user)
    GithubFulfillment.new(self, user).fulfill
  end

  def remove_collaborator(user)
    if has_collaborator?(user)
      GithubFulfillment.new(self, user).remove
      collaborations.find_by(user_id: user).destroy
    end
  end

  def has_collaborator?(user)
    collaborations.exists?(user_id: user)
  end

  def has_github_collaborator?(user)
    github_client.collaborator?(github_repository, user.github_username)
  end

  def to_s
    github_url
  end

  private

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
