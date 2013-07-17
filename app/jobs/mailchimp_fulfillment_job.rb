class MailchimpFulfillmentJob < MailchimpJob
  MASTER_LIST_ID = '66f4d45e54'

  def perform
    lists = client.lists(filters: { list_name: list_name })
    subscribe(lists['data'].first['id'], email)
    subscribe(MASTER_LIST_ID, email)
  end

  private

  def subscribe(list_id, email)
    rescue_email_errors do
      client.list_subscribe(id: list_id, email_address: email, double_optin: false)
    end
  end
end
