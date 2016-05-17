require "rails_helper"

describe GithubRemovalJob do
  it_behaves_like "a Delayed Job that notifies Honeybadger about errors"

  it "removes a collaborator from a GitHub repo" do
    client = stub_octokit
    allow(client).to receive(:remove_collaborator).and_return(nil)

    GithubRemovalJob.perform_later("thoughtbot/upcase", "gabebw")

    expect(client).
      to have_received(:remove_collaborator).
      with("thoughtbot/upcase", "gabebw")
  end

  [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
    it "notifies Honeybadger when #{error_class} is raised" do
      client = stub_octokit
      allow(client).to receive(:remove_collaborator).and_raise(error_class)
      allow(Honeybadger).to receive(:notify)

      GithubRemovalJob.perform_later("thoughtbot/upcase", "gabebw")

      expect(Honeybadger).to have_received(:notify).
        with(instance_of(error_class))
    end
  end

  def stub_octokit
    spy("Octokit::Client").tap do |client|
      allow(Octokit::Client).to receive(:new).and_return(client)
    end
  end
end
