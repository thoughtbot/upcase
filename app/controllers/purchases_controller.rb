class PurchasesController < ApplicationController
  def new
    if current_user_has_active_subscription?
      redirect_to subscriber_purchase_url
    else
      @purchase = build_purchase_with_defaults
    end
  end

  def create
    @purchase = find_purchaseable.purchases.build(params[:purchase])
    @purchase.user = current_user
    @purchase.coupon = current_coupon
    @purchase.stripe_customer_id = existing_stripe_customer_id

    if @purchase.save
      notify_kissmetrics_of(@purchase)
      sign_in_purchasing_user(@purchase)

      redirect_to success_url,
        notice: t('.purchase.flashes.success', name: @purchase.purchaseable_name),
        flash: { purchase_paid_price: @purchase.paid_price }
    else
      render :new
    end
  end

  def show
    @purchase = Purchase.find_by_lookup(params[:id])
    @purchaseable = @purchase.purchaseable
    if @purchase.paid?
      render polymorphic_purchaseable_template
    else
      redirect_to @purchaseable
    end
  end

  def paypal
    flash.keep
    @purchase = Purchase.find_by_lookup(params[:id])
    @purchase.complete_paypal_payment!(params[:token], params[:PayerID])
    notify_kissmetrics_of(@purchase)
    redirect_to @purchase
  end

  private

  def subscriber_purchase_url
    polymorphic_url([:new, :subscriber, find_purchaseable, :purchase])
  end

  def build_purchase_with_defaults
    purchase = find_purchaseable.purchases.build(variant: params[:variant])
    purchase.defaults_from_user(current_user)
    purchase
  end

  def sign_in_purchasing_user(purchase)
    if signed_out? && purchase.user
      sign_in purchase.user
    end
  end

  def notify_kissmetrics_of(purchase)
    event_notifier = KissmetricsEventNotifier.new
    event_notifier.notify_of_purchase(purchase)
  end

  def existing_stripe_customer_id
    if signed_in? && using_existing_card?
      current_user.stripe_customer_id
    end
  end

  def using_existing_card?
    params[:use_existing_card] == 'on'
  end

  def current_coupon
    if params[:coupon_id].present?
      Coupon.active.find_by_id(params[:coupon_id])
    end
  end

  def success_url
    if @purchase.paypal?
      @purchase.paypal_url
    elsif @purchase.subscription?
      products_path
    else
      purchase_path @purchase
    end
  end

  def url_after_denied_access_when_signed_out
    sign_up_url
  end

  def polymorphic_purchaseable_template
    "#{@purchaseable.product_type.pluralize}/#{@purchaseable.product_type}_purchase_show"
  end
end
