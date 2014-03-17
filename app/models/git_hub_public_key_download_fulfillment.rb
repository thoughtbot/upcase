class GitHubPublicKeyDownloadFulfillment
  def initialize(user)
    @user = user
  end

  def fulfill
    github_keys.each do |github_key|
      @user.public_keys.create!(data: github_key[:key])
    end
  end

  private

  def github_keys
    github_client.user_keys(@user.github_username)
  end

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
