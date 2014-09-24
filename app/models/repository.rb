class Repository < Product
  validates :github_team, presence: true
  validates :github_url, presence: true

  def included_in_plan?(plan)
    plan.has_feature?(:repositories)
  end

  def has_github_member?(user)
    github_client.team_member?(github_team, user.github_username)
  end

  private

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
