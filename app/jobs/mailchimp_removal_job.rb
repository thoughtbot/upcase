class MailchimpRemovalJob < MailchimpJob
  def perform
    lists = client.lists(filters: { list_name: list_name })
    client.list_unsubscribe(id: lists['data'].first['id'], email_address: email)
  end
end
