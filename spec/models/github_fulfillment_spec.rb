require "rails_helper"

describe GithubFulfillment do
  describe "#fulfill" do
    it "adds a collaborator to the GitHub repo" do
      repository = build_stubbed(:repository)
      user = build_stubbed(:user, github_username: "github_username")
      allow(GithubFulfillmentJob).to receive(:perform_later)

      GithubFulfillment.new(repository, user).fulfill

      expect(GithubFulfillmentJob).to have_received(:perform_later).
        with(repository.id, user.id)
    end

    it "doesn't fulfill using GitHub with a blank GitHub repo" do
      repository = build_stubbed(:show, github_repository: nil)
      user = build_stubbed(:user, github_username: "github_username")
      allow(GithubFulfillmentJob).to receive(:perform_later)

      GithubFulfillment.new(repository, user).fulfill

      expect(GithubFulfillmentJob).not_to have_received(:perform_later)
    end
  end

  describe "#remove" do
    it "removes a collaborator from the GitHub repo" do
      allow(GithubRemovalJob).to receive(:perform_later)
      repository = build_stubbed(:repository)
      user = build_stubbed(:user, github_username: "test")

      GithubFulfillment.new(repository, user).remove

      expect(GithubRemovalJob).to have_received(:perform_later).
        with(repository.github_repository, "test")
    end

    it "doesn't remove using GitHub with a blank GitHub repo" do
      allow(GithubRemovalJob).to receive(:perform_later)
      repository = build(:show, github_repository: nil)
      user = create(:user, github_username: "test")

      GithubFulfillment.new(repository, user).remove

      expect(GithubRemovalJob).not_to have_received(:perform_later)
    end
  end
end
