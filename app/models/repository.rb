class Repository < Product
  has_many :collaborations, dependent: :destroy

  validates :github_team, presence: true
  validates :github_url, presence: true

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

  def has_github_member?(user)
    github_client.team_member?(github_team, user.github_username)
  end

  private

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
