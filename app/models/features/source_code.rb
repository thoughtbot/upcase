module Features
  class SourceCode
    GITHUB_TEAM = 516450

    def initialize(user:)
      @user = user
    end

    def fulfill
      GithubFulfillmentJob.enqueue(GITHUB_TEAM, [user.github_username])
    end

    def unfulfill
      GithubRemovalJob.enqueue(GITHUB_TEAM, [user.github_username])
    end

    private

    attr_reader :user
  end
end
