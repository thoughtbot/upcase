require "spec_helper"

describe GithubFulfillmentJob do
  it_behaves_like "a Delayed Job that notifies Airbrake about errors"

  it "adds the given username to a github team" do
    client = stub_octokit
    client.stubs(add_team_membership: nil)

    GithubFulfillmentJob.new(3, "gabebw").perform

    expect(client).to(
      have_received(:add_team_membership).
      with(3, "gabebw", accept: GithubFulfillmentJob::PREVIEW_MEDIA_TYPE)
    )
  end

  [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
    it "sends an email when #{error_class} is raised" do
      license_id = create(:license).id
      client = stub_octokit
      client.stubs(:add_team_membership).raises(error_class)
      LicenseMailer.stubs(fulfillment_error: stub("deliver", :deliver => true))

      expect { GithubFulfillmentJob.new(3, "gabebw", license_id).perform }.
        to raise_error(error_class)

      expect(LicenseMailer).to have_received(:fulfillment_error).
        with(instance_of(License), "gabebw")
    end

    it "sends no email when #{error_class} is raised with no license" do
      client = stub_octokit
      client.stubs(:add_team_membership).raises(error_class)
      LicenseMailer.stubs(fulfillment_error: stub("deliver", deliver: true))

      expect { GithubFulfillmentJob.new(3, "gabebw").perform }.
        to raise_error(error_class)

      expect(LicenseMailer).to(
        have_received(:fulfillment_error).
        with(instance_of(License), "gabebw").
        never
      )
    end
  end

  def stub_octokit
    stub("Octokit::Client").tap do |client|
      Octokit::Client.stubs(new: client)
    end
  end
end
