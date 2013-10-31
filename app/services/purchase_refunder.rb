class PurchaseRefunder < SimpleDelegator
  def refund
    if paid?
      payment.refund
      set_as_unpaid_and_save
      remove_fullfilments
    end
  end

  private

  def remove_fullfilments
    if fulfilled_with_github?
      GithubFulfillment.new(self).remove
    end
    MailchimpFulfillment.new(self).remove
  end

  def set_as_unpaid_and_save
    set_as_unpaid
    save!
  end
end
