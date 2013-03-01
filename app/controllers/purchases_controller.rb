class PurchasesController < ApplicationController
  def new
    @purchaseable = find_purchaseable

    if current_user_has_active_subscription?
      render 'for_subscribers'
    else
      @purchase = @purchaseable.purchases.build(variant: params[:variant])
      @purchase.defaults_from_user(current_user)
      @active_card = retrieve_active_card

      if @purchase.subscription? && signed_out?
        deny_access(t('shared.subscriptions.user_required'))
      end
    end
  end

  def create
    @purchaseable = find_purchaseable
    @purchase = @purchaseable.purchases.build(params[:purchase])
    @purchase.user = current_user

    if use_coupon?
      @purchase.coupon = Coupon.active.find_by_id(params[:coupon_id])
    end

    if use_existing_card?
      @purchase.stripe_customer = current_user.stripe_customer
    end

    if @purchase.save
      create_subscription if @purchaseable.subscription?

      notify_kissmetrics_of(@purchase)

      redirect_to success_url, notice: t('.purchase.flashes.success', name: @purchaseable.name)
    else
      @active_card = retrieve_active_card
      render :new
    end
  end

  def show
    @purchase = Purchase.find_by_lookup(params[:id])
    @purchaseable = @purchase.purchaseable
    unless @purchase.paid?
      redirect_to @purchaseable
    end
  end

  def watch
    @purchase = Purchase.find_by_lookup(params[:id])
    unless @purchase.paid?
      redirect_to root_path and return
    end
    @purchaseable = @purchase.purchaseable

    if @purchaseable.videos.one?
      redirect_to [@purchase, @purchaseable.videos.first]
    else
      redirect_to [@purchase, :videos]
    end
  end

  def paypal
    @purchase = Purchase.find_by_lookup(params[:id])
    @purchase.complete_paypal_payment!(params[:token], params[:PayerID])
    notify_kissmetrics_of(@purchase)
    redirect_to @purchase
  end

  private

  def create_subscription
    current_user.create_subscription
  end

  def notify_kissmetrics_of(purchase)
    event_notifier = KissmetricsEventNotifier.new(km_http_client)
    event_notifier.notify_of(purchase)
  end

  def use_existing_card?
    params[:use_existing_card] == 'on'
  end

  def use_coupon?
    params[:coupon_id].present?
  end

  def retrieve_active_card
    if current_user && current_user.stripe_customer
      Stripe::Customer.retrieve(current_user.stripe_customer)['active_card']
    end
  end

  def current_purchase
    @current_purchase ||= Purchase.find_by_lookup(params[:id])
  end

  def current_purchaseable
    @current_purchaseable ||= purchaseable
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
end
