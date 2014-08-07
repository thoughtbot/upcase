require 'rails_helper'

describe GitHubPublicKeyDownloadFulfillment, type: :model do
  describe '#fulfill' do
    it "uses the GitHub API to download the user's API keys" do
      public_keys = stub('public_keys')
      public_keys.stubs(:create!)
      user = build_stubbed(:user, :with_github)
      user.stubs(:public_keys).returns(public_keys)
      fulfillment = GitHubPublicKeyDownloadFulfillment.new(user)
      github_keys = [
        Hashie::Mash.new(key: 'key-one'),
        Hashie::Mash.new(key: 'key-two')
      ]
      github_client = stub('github_client')
      Octokit::Client
        .stubs(:new)
        .with(login: GITHUB_USER, password: GITHUB_PASSWORD)
        .returns(github_client)
      github_client
        .stubs(:user_keys)
        .with(user.github_username)
        .returns(github_keys)

      fulfillment.fulfill

      github_keys.each do |github_key|
        expect(public_keys)
          .to have_received(:create!).with(data: github_key[:key])
      end
    end
  end
end
