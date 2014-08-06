require "spec_helper"

describe Features::SourceCode do
  describe "#fulfill" do
    it "adds the user to the subscriber github team" do
      GithubFulfillmentJob.stubs(:enqueue)
      user = build_stubbed(:user, :with_github)
      Features::SourceCode.new(user: user).fulfill

      expect(GithubFulfillmentJob).to have_received(:enqueue).
        with(Features::SourceCode::GITHUB_TEAM, user.github_username)
    end
  end

  describe "#unfulfill" do
    it "removes the user from the subscriber github team" do
      GithubRemovalJob.stubs(:enqueue)
      user = build_stubbed(:user, :with_github)
      Features::SourceCode.new(user: user).unfulfill

      expect(GithubRemovalJob).to have_received(:enqueue).
        with(Features::SourceCode::GITHUB_TEAM, user.github_username)
    end
  end
end
