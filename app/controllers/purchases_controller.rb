class PurchasesController < ApplicationController
  def new
    if current_user_purchase_is_free? || user_wants_to_take_a_workshop?
      redirect_to_purchase_or_subscription_path
    else
      @purchase = build_purchase_with_defaults
    end
  end

  def create
    @purchase = requested_purchaseable.purchases.build(purchase_params)
    @purchase.user = current_user
    @purchase.coupon = current_coupon
    @purchase.stripe_customer_id = existing_stripe_customer_id

    if @purchase.save
      notify_kissmetrics_of(@purchase)
      sign_in_purchasing_user(@purchase)

      redirect_to success_url,
        notice: t('purchase.flashes.success', name: @purchase.purchaseable_name),
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
    @purchase.complete_payment(params)
    notify_kissmetrics_of(@purchase)
    redirect_to @purchase
  end

  private

  def current_user_purchase_is_free?
    current_user_has_active_subscription? &&
      (plan_purchase? || included_in_subscription?)
  end

  def user_wants_to_take_a_workshop?
    params[:section_id].present?
  end

  def redirect_to_purchase_or_subscription_path
    if current_user_purchase_is_free?
      redirect_to_subscriber_purchase_or_default(dashboard_path)
    else
      redirect_to new_subscription_path
    end
  end

  def redirect_to_subscriber_purchase_or_default(default_path)
    if plan_purchase?
      flash[:error] = I18n.t('subscriber_purchase.flashes.error')
      redirect_to default_path
    else
      redirect_to subscriber_purchase_url
    end
  end

  def included_in_subscription?
    !workshop_purchase? || (workshop_purchase? && subscription_includes_workshops?)
  end

  def plan_purchase?
    params[:individual_plan_id].present? || params[:team_plan_id].present?
  end

  def workshop_purchase?
    params[:section_id].present?
  end

  def subscriber_purchase_url
    polymorphic_url([:new, :subscriber, requested_purchaseable, :purchase])
  end

  def build_purchase_with_defaults
    purchase = requested_purchaseable.purchases.build(variant: variant)
    purchase.defaults_from_user(current_user)
    purchase.mentor_id = cookies[:mentor_id]
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
      dashboard_path
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

  def purchase_params
    params.require(:purchase).permit(:stripe_coupon_id, :variant,
      :name, :email, :password, {:github_usernames => []}, :organization,
      :address1, :address2, :city, :state, :zip_code, :country,
      :payment_method, :stripe_token, :comments, :mentor_id)
  end

  def variant
    if params[:variant].present?
      params[:variant]
    else
      'individual'
    end
  end
end
