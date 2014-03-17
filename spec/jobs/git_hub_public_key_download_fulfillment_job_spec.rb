require 'spec_helper'

describe GitHubPublicKeyDownloadFulfillmentJob do
  describe '.enqueue' do
    it 'enqueues a new job' do
      user = build_stubbed(:user, :with_github)
      Delayed::Job.stubs(:enqueue)

      GitHubPublicKeyDownloadFulfillmentJob.enqueue(user.id)

      expect(Delayed::Job).to have_received(:enqueue).with(
        kind_of(GitHubPublicKeyDownloadFulfillmentJob),
        priority: GitHubPublicKeyDownloadFulfillmentJob::PRIORITY
      )
    end
  end

  describe '#perform' do
    it "downloads the user's public keys from GitHub" do
      user = build_stubbed(:user, :with_github)
      User.stubs(:find).with(user.id).returns(user)
      fulfillment = stub('fulfillment', fulfill: true)
      GitHubPublicKeyDownloadFulfillment
        .stubs(:new)
        .with(user)
        .returns(fulfillment)
      job = GitHubPublicKeyDownloadFulfillmentJob.new(user.id)

      job.perform

      expect(fulfillment).to have_received(:fulfill)
    end
  end
end
