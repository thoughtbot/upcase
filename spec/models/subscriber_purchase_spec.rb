require 'spec_helper'

describe '#create' do
  it 'sets the payment_method on Purchase to free' do
    user = create(:user, :with_subscription)
    create_subscriber_purchase(create(:book_product), user)
    user.purchases.last.payment_method.should == 'free'
  end

  context 'when the purchaseable is a github fulfilled product' do
    it 'enqueues a job to add the subscriber to the repo' do
      AddGithubTeamMemberJob.stubs(:enqueue)
      user = create(:user, :with_subscription, github_username: 'github_username')
      product = create(:github_book_product)

      create_subscriber_purchase(product, user)

      AddGithubTeamMemberJob.should have_received(:enqueue).
        with(product.github_team, user.github_username, Purchase.last.id)
    end
  end

  def create_subscriber_purchase(product, user)
    SubscriberPurchase.new(product, user).create
  end
end
