module PurchasesHelper
  def display_card_type(type)
    if type == "American Express"
      "AMEX"
    else
      type
    end
  end
end
