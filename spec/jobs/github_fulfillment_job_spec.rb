require "rails_helper"

describe GithubFulfillmentJob do
  it_behaves_like "a Delayed Job that notifies Airbrake about errors"

  describe "#perform" do
    context "with a GitHub username" do
      it "adds the given user to a repository's GitHub team" do
        client = stub_octokit
        client.stubs(add_team_membership: nil)
        repository = stub_repository(github_team: 3)
        user = stub_user(github_username: "gabebw")

        GithubFulfillmentJob.new(repository.id, user.id).perform

        expect(client).to(
          have_received(:add_team_membership).
          with(
            repository.github_team,
            user.github_username,
            accept: GithubFulfillmentJob::PREVIEW_MEDIA_TYPE
          )
        )
      end
    end

    context "without a GitHub username" do
      it "doesn't call GitHub" do
        client = stub_octokit
        client.stubs(add_team_membership: nil)
        repository = stub_repository(github_team: 3)
        user = stub_user(github_username: nil)

        GithubFulfillmentJob.new(repository.id, user.id).perform

        expect(client).to have_received(:add_team_membership).never
      end
    end

    [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
      context "when #{error_class} is raised" do
        it "sends an email" do
          client = stub_octokit
          client.stubs(:add_team_membership).raises(error_class)
          mailer = stub("mailer")
          mailer.stubs(:deliver_now)
          repository = stub_repository
          user = stub_user(github_username: "gabebw")
          LicenseMailer.
            stubs(:fulfillment_error).
            with(repository, user).
            returns(mailer)
          job = GithubFulfillmentJob.new(repository.id, user.id)

          expect { job.perform }.to raise_error(error_class)
          expect(mailer).to have_received(:deliver_now)
        end
      end
    end
  end

  def stub_repository(attributes = {})
    build_stubbed(:repository, attributes).tap do |repository|
      Product.stubs(:find).with(repository.id).returns(repository)
    end
  end

  def stub_user(attributes = {})
    build_stubbed(:user, attributes).tap do |user|
      User.stubs(:find).with(user.id).returns(user)
    end
  end

  def stub_octokit
    stub("Octokit::Client").tap do |client|
      Octokit::Client.stubs(new: client)
    end
  end
end
