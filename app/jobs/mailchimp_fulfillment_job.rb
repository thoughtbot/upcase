class MailchimpFulfillmentJob < MailchimpJob
  MASTER_LIST_ID = '719485'

  def perform
    lists = client.lists(filters: { list_name: list_name })
    client.list_subscribe(id: lists['data'].first['id'], email_address: email)
    client.list_subscribe(id: MASTER_LIST_ID, email_address: email)
  end
end
