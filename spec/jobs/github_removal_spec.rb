require "rails_helper"

describe GithubRemovalJob do
  it_behaves_like "a Delayed Job that notifies Airbrake about errors"

  it "removes a username from a github team" do
    client = stub_octokit
    allow(client).to receive(:remove_team_member).and_return(nil)

    GithubRemovalJob.new(3, "gabebw").perform

    expect(client).to have_received(:remove_team_member).with(3, "gabebw")
  end

  [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
    it "notifies Airbrake when #{error_class} is raised" do
      client = stub_octokit
      allow(client).to receive(:remove_team_member).and_raise(error_class)
      allow(Airbrake).to receive(:notify)

      GithubRemovalJob.new(3, "gabebw").perform

      expect(Airbrake).to have_received(:notify).with(instance_of(error_class))
    end
  end

  def stub_octokit
    spy("Octokit::Client").tap do |client|
      allow(Octokit::Client).to receive(:new).and_return(client)
    end
  end
end
