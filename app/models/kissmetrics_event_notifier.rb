class KissmetricsEventNotifier
  def initialize(client)
    @client = client
  end

  def notify_of(purchase)
    @client.record(purchase.email,
                   'Billed',
                    { 'Product Name' => purchase.name, 'Amount Billed' => purchase.price })
  end
end
