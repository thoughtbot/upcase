require 'spec_helper'

describe GithubFulfillmentJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  it 'adds given usernames to a github team' do
    client = stub_octokit
    client.stubs(:add_team_member => nil)

    GithubFulfillmentJob.new(3, ['gabebw', 'cpytel'], 1).perform

    client.should have_received(:add_team_member).with(3, 'gabebw')
    client.should have_received(:add_team_member).with(3, 'cpytel')
  end

  [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
    it "sends an email when #{error_class} is raised" do
      purchase_id = create(:purchase).id
      client = stub_octokit
      client.stubs(:add_team_member).raises(error_class)
      Mailer.stubs(:fulfillment_error => stub("deliver", :deliver => true))

      GithubFulfillmentJob.new(3, ['gabebw'], purchase_id).perform

      Mailer.should have_received(:fulfillment_error).
        with(instance_of(Purchase), 'gabebw')
    end

    it "notifies Airbrake when #{error_class} is raised" do
      purchase_id = create(:purchase).id
      client = stub_octokit
      client.stubs(:add_team_member).raises(error_class)
      Airbrake.stubs(:notify)

      GithubFulfillmentJob.new(3, ['gabebw'], purchase_id).perform

      Airbrake.should have_received(:notify).once
    end
  end


  def stub_octokit
    stub("Octokit::Client").tap do |client|
      Octokit::Client.stubs(:new =>  client)
    end
  end
end
