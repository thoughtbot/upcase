class TapasPaymentsController < ApplicationController
  # Normal prices:
  # TIER_1_PRICE = 39900
  # TIER_2_PRICE = 59900
  # TIER_3_PRICE = 49900
  # TIER_4_PRICE = 149900

  # 10% off
  TIER_1_PRICE = 35900
  TIER_2_PRICE = 53900
  TIER_3_PRICE = 44900
  TIER_4_PRICE = 134900

  def create
    Stripe::Charge.create(
      amount: amount,
      currency: "USD",
      source: params["stripeToken"],
      receipt_email: email,
      metadata: { email: email, tier: tier, quantity: quantity }
    )

    flash[:notice] = "Success!"
  rescue Stripe::CardError => error
    flash[:error] = "Charge failed"
    render :error
  end

  private

  def amount
    case tier
    when 1
      TIER_1_PRICE
    when 2
      TIER_2_PRICE
    when 3
      TIER_3_PRICE * quantity
    when 4
      TIER_4_PRICE * quantity
    else
      raise "Invalid tier specified"
    end
  end

  def quantity
    if params[:quantity]
      params[:quantity].to_i
    else
      1
    end
  end

  def tier
    params[:tier].to_i
  end

  def email
    params["stripeEmail"]
  end
end
