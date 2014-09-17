require "rails_helper"

describe GithubFulfillment do
  describe "#fulfill" do
    it "adds GitHub user to the github team" do
      product = build(:video_tutorial, :github)
      user = create(:user, github_username: "github_username")
      GithubFulfillmentJob.stubs(:enqueue)
      license = build(
        :license,
        licenseable: product,
        user: user
      )

      GithubFulfillment.new(license).fulfill

      expect(GithubFulfillmentJob).to have_received(:enqueue)
    end

    it "doesn't fulfill using GitHub with a blank GitHub team" do
      product = build(:video_tutorial, github_team: nil)
      user = create(:user, github_username: "github_username")
      GithubFulfillmentJob.stubs(:enqueue)
      license = build(
        :license,
        licenseable: product,
        user: user
      )

      GithubFulfillment.new(license).fulfill

      expect(GithubFulfillmentJob).to have_received(:enqueue).never
    end
  end

  describe "#remove" do
    it "removes user from github team" do
      GithubRemovalJob.stubs(:enqueue)
      user = create(:user, github_username: "test")
      product = build(:video_tutorial, :github)
      license = build(
        :license,
        licenseable: product,
        user: user
      )

      GithubFulfillment.new(license).remove

      expect(GithubRemovalJob).to have_received(:enqueue).
        with(product.github_team, "test")
    end

    it "doesn't remove using GitHub with a blank GitHub team" do
      GithubRemovalJob.stubs(:enqueue)
      user = create(:user, github_username: "test")
      product = build(:video_tutorial, github_team: nil)
      license = build(
        :license,
        licenseable: product,
        user: user
      )

      GithubFulfillment.new(license).remove

      expect(GithubRemovalJob).to have_received(:enqueue).never
    end
  end
end
