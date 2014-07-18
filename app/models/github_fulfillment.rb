class GithubFulfillment
  def initialize(license)
    @license = license
  end

  def fulfill
    if fulfilled_with_github?
      GithubFulfillmentJob.enqueue(team, username, @license.id)
    end
  end

  def remove
    if fulfilled_with_github?
      GithubRemovalJob.enqueue(team, username)
    end
  end

  private

  def fulfilled_with_github?
    team.present?
  end

  def team
    licenseable.github_team
  end

  def licenseable
    @license.licenseable
  end

  def username
    @license.github_username
  end
end
