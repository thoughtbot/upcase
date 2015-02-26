require "rails_helper"

describe GithubFulfillmentJob do
  it_behaves_like "a Delayed Job that notifies Airbrake about errors"

  describe "#perform" do
    context "with a GitHub username" do
      it "adds the given user to a GitHub repository" do
        client = stub_octokit
        allow(client).to receive(:add_collaborator).and_return(nil)
        repository = stub_repository(github_repository: "thoughtbot/upcase")
        user = stub_user(github_username: "gabebw")

        GithubFulfillmentJob.new(repository.id, user.id).perform

        expect(client).to(
          have_received(:add_collaborator).
          with(
            repository.github_repository,
            user.github_username,
            accept: GithubFulfillmentJob::PREVIEW_MEDIA_TYPE,
            permission: GithubFulfillmentJob::READ_ONLY_PERMISSION
          )
        )
      end
    end

    context "without a GitHub username" do
      it "doesn't call GitHub" do
        client = stub_octokit
        allow(client).to receive(:add_collaborator).and_return(nil)
        repository = stub_repository(github_repository: "thoughtbot/upcase")
        user = stub_user(github_username: nil)

        GithubFulfillmentJob.new(repository.id, user.id).perform

        expect(client).not_to have_received(:add_collaborator)
      end
    end

    [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
      context "when #{error_class} is raised" do
        it "sends an email" do
          client = stub_octokit
          allow(client).to receive(:add_collaborator).and_raise(error_class)
          mailer = spy("mailer")
          repository = stub_repository
          user = stub_user(github_username: "gabebw")
          allow(LicenseMailer).to receive(:fulfillment_error).
            with(repository, user).
            and_return(mailer)
          job = GithubFulfillmentJob.new(repository.id, user.id)

          expect { job.perform }.to raise_error(error_class)
          expect(mailer).to have_received(:deliver_now)
        end
      end
    end
  end

  def stub_repository(attributes = {})
    build_stubbed(:repository, attributes).tap do |repository|
      allow(Product).to receive(:find).with(repository.id).
        and_return(repository)
    end
  end

  def stub_user(attributes = {})
    build_stubbed(:user, attributes).tap do |user|
      allow(User).to receive(:find).with(user.id).and_return(user)
    end
  end

  def stub_octokit
    spy("Octokit::Client").tap do |client|
      allow(Octokit::Client).to receive(:new).and_return(client)
    end
  end
end
