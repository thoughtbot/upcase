class SendPurchaseReceiptEmailJob < Struct.new(:purchase_id)
  include ErrorReporting

  def self.enqueue(purchase_id)
    Delayed::Job.enqueue(new(purchase_id))
  end

  def perform
    purchase = Purchase.find(purchase_id)
    Mailer.purchase_receipt(purchase).deliver
  end
end
