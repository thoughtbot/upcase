require 'spec_helper'

describe GithubFulfillment do
  describe 'fulfill' do
    it "doesn't add users to the github team when there are blank usernames" do
      product = create(:github_book_product)
      GithubFulfillmentJob.stubs(:enqueue)
      purchase = build(
        :book_purchase,
        purchaseable: product, 
        github_usernames: ['', '']
      )

      GithubFulfillment.new(purchase).fulfill

      GithubFulfillmentJob.should have_received(:enqueue).never
    end

    it 'adds user to the github team' do
      product = build(:github_book_product)
      GithubFulfillmentJob.stubs(:enqueue)
      purchase = build(
        :book_purchase,
        purchaseable: product, 
        github_usernames: ['cpytel']
      )

      GithubFulfillment.new(purchase).fulfill

      GithubFulfillmentJob.should have_received(:enqueue).
        with(product.github_team, ['cpytel'], purchase.id)
    end

    it 'adds multiple users to the github team' do
      product = build(:github_book_product)
      GithubFulfillmentJob.stubs(:enqueue)
      purchase = build(
        :book_purchase,
        purchaseable: product, 
        github_usernames: ['cpytel', 'github_username2']
      )

      GithubFulfillment.new(purchase).fulfill

      GithubFulfillmentJob.should have_received(:enqueue).
        with(product.github_team, ['cpytel', 'github_username2'], purchase.id)
    end
  end

  describe 'remove' do
    it 'removes user from github team' do
      GithubRemovalJob.stubs(:enqueue)
      product = build(:github_book_product)
      purchase = build(
        :book_purchase,
        purchaseable: product, 
        github_usernames: ['jayroh', 'cpytel']
      )

      GithubFulfillment.new(purchase).remove

      GithubRemovalJob.should have_received(:enqueue).
        with(product.github_team, ['jayroh', 'cpytel'])
    end
  end
end
