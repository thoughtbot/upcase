require 'spec_helper'

describe GithubFulfillmentJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  it 'adds the given username to a github team' do
    client = stub_octokit
    client.stubs(:add_team_member => nil)

    GithubFulfillmentJob.new(3, 'gabebw').perform

    client.should have_received(:add_team_member).with(3, 'gabebw')
  end

  [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
    it "sends an email when #{error_class} is raised" do
      purchase_id = create(:purchase).id
      client = stub_octokit
      client.stubs(:add_team_member).raises(error_class)
      PurchaseMailer.stubs(:fulfillment_error => stub("deliver", :deliver => true))

      expect { GithubFulfillmentJob.new(3, 'gabebw', purchase_id).perform }.
        to raise_error(error_class)

      PurchaseMailer.should have_received(:fulfillment_error).
        with(instance_of(Purchase), 'gabebw')
    end

    it "sends no email when #{error_class} is raised with no purchase" do
      client = stub_octokit
      client.stubs(:add_team_member).raises(error_class)
      PurchaseMailer.stubs(fulfillment_error: stub("deliver", deliver: true))

      expect { GithubFulfillmentJob.new(3, 'gabebw').perform }.
        to raise_error(error_class)

      expect(PurchaseMailer).to(
        have_received(:fulfillment_error).
          with(instance_of(Purchase), 'gabebw').
          never
      )
    end
  end


  def stub_octokit
    stub("Octokit::Client").tap do |client|
      Octokit::Client.stubs(:new =>  client)
    end
  end
end
