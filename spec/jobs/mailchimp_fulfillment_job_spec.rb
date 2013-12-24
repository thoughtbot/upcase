require 'spec_helper'

describe MailchimpFulfillmentJob do
  it_behaves_like 'a Delayed Job that notifies Airbrake about errors'
  it_behaves_like 'a MailchimpJob'

  it 'adds an email to the given list and the master list' do
    FakeMailchimp.master_list = MailchimpFulfillmentJob::MASTER_LIST_ID

    MailchimpFulfillmentJob.new('product', 'user@example.com').perform

    master_list = FakeMailchimp.lists[MailchimpFulfillmentJob::MASTER_LIST_ID]
    expect(master_list).to include 'user@example.com'
    expect(FakeMailchimp.lists['product']).to include 'user@example.com'
  end

  it 'notifies Airbrake if the mailing list is missing' do
    Gibbon.stubs new: stub(lists: {"total"=>0, "data"=>[]}, list_subscribe: true)
    Airbrake.stubs(:notify_or_ignore)

    MailchimpFulfillmentJob.new('product', 'user@example.com').perform

    expect(Airbrake).to have_received(:notify_or_ignore)
  end
end
