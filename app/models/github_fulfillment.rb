class GithubFulfillment
  def initialize(repository, user)
    @repository = repository
    @user = user
  end

  def fulfill
    if fulfilled_with_github?
      GithubFulfillmentJob.perform_later(@repository.id, @user.id)
    end
  end

  def remove
    if fulfilled_with_github?
      GithubRemovalJob.perform_later(github_repository, github_username)
    end
  end

  private

  def fulfilled_with_github?
    github_repository.present?
  end

  def github_repository
    @repository.github_repository
  end

  def github_username
    @user.github_username
  end
end
