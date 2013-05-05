require 'spec_helper'

describe GithubRemovalJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'

  it 'removes a username from a github team' do
    client = stub_octokit
    client.stubs(:remove_team_member => nil)

    GithubRemovalJob.new(3, ['gabebw', 'cpytel']).perform

    client.should have_received(:remove_team_member).with(3, 'gabebw')
    client.should have_received(:remove_team_member).with(3, 'cpytel')
  end

  [Octokit::NotFound, Net::HTTPBadResponse].each do |error_class|
    it "notifies Airbrake when #{error_class} is raised" do
      client = stub_octokit
      client.stubs(:remove_team_member).raises(error_class)
      Airbrake.stubs(:notify)

      GithubRemovalJob.new(3, ['gabebw']).perform

      Airbrake.should have_received(:notify).with(instance_of(error_class))
    end
  end

  def stub_octokit
    stub('Octokit::Client').tap do |client|
      Octokit::Client.stubs(:new =>  client)
    end
  end
end
