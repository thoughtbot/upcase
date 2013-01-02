require 'spec_helper'

describe AddGithubTeamMemberJob do
  it 'adds a username to a github team' do
    client = stub_octokit
    client.stubs(:add_team_member => nil)
    AddGithubTeamMemberJob.new(3, 'gabebw', 1).perform
    client.should have_received(:add_team_member).with(3, 'gabebw')
  end

  [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
    it "sends an email when #{error_class} is raised" do
      purchase_id = create(:purchase).id
      client = stub_octokit
      client.stubs(:add_team_member).raises(error_class)
      Mailer.stubs(:fulfillment_error => stub("deliver", :deliver => true))
      AddGithubTeamMemberJob.new(3, 'gabebw', purchase_id).perform

      Mailer.should have_received(:fulfillment_error).
        with(instance_of(Purchase), 'gabebw')
    end
  end

  def stub_octokit
    stub("Octokit::Client").tap do |client|
      Octokit::Client.stubs(:new =>  client)
    end
  end
end
