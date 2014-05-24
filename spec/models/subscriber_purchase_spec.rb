require 'spec_helper'

describe '#create' do
  it 'sets the payment_method on Purchase to subscription' do
    user = create(:subscriber)
    create_subscriber_purchase(create(:book), user)
    expect(user.purchases.last.payment_method).to eq 'subscription'
  end

  context 'when the purchaseable is a github fulfilled product' do
    it 'enqueues a job to add the subscriber to the repo' do
      GithubFulfillmentJob.stubs(:enqueue)
      user = create(:subscriber, github_username: 'github_username')
      product = create(:book, :github)

      create_subscriber_purchase(product, user)

      expect(GithubFulfillmentJob).to have_received(:enqueue).
        with(product.github_team, [user.github_username], Purchase.last.id)
    end
  end

  def create_subscriber_purchase(product, user)
    SubscriberPurchase.new(product, user).create
  end
end
