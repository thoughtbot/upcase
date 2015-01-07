class GithubFulfillment
  def initialize(repository, user)
    @repository = repository
    @user = user
  end

  def fulfill
    if fulfilled_with_github?
      GithubFulfillmentJob.enqueue(@repository.id, @user.id)
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
    @repository.github_team
  end

  def username
    @user.github_username
  end
end
