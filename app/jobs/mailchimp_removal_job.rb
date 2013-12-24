class MailchimpRemovalJob < MailchimpJob
  def perform
    rescue_email_errors do
      lists = client.lists(filters: { list_name: list_name })

      if lists['total'] > 0
        client.list_unsubscribe(id: lists['data'].first['id'], email_address: email)
      end
    end
  end
end
