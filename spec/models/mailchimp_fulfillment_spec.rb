require 'spec_helper'

describe MailchimpFulfillment do
  describe 'fulfill' do
    it 'triggers the job to add the user to mailchimp lists' do
      product = create(:github_book_product)
      MailchimpFulfillmentJob.stubs(:enqueue)
      purchase = build(
        :book_purchase,
        purchaseable: product,
        email: 'user@example.com'
      )

      MailchimpFulfillment.new(purchase).fulfill

      MailchimpFulfillmentJob.should have_received(:enqueue).
        with(product.sku, 'user@example.com')
    end
  end

  describe 'remove' do
    it 'triggers the job to remove the purchaser from mailchimp lists' do
      MailchimpRemovalJob.stubs(:enqueue)
      product = build(:github_book_product)
      purchase = build(
        :book_purchase,
        purchaseable: product, 
        email: 'user@example.com'
      )

      MailchimpFulfillment.new(purchase).remove

      MailchimpRemovalJob.should have_received(:enqueue).
        with(product.sku, 'user@example.com')
    end
  end
end
