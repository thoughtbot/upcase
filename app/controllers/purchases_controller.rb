class PurchasesController < ApplicationController
  def new
    @purchaseable = purchaseable
    @purchase = @purchaseable.purchases.build(variant: params[:variant])
    @purchase.defaults_from_user(current_user)
    @active_card = retrieve_active_card
    track_chrome_screencast_ab_test_completion
    km.record("Checkout", { "Product Name" => @purchaseable.name, "Order Total" => @purchase.price })
  end

  def create
    @purchaseable = purchaseable
    @purchase = @purchaseable.purchases.build(params[:purchase])
    @purchase.user = current_user

    if use_coupon?
      @purchase.coupon = Coupon.active.find_by_id(params[:coupon_id])
    end

    if use_existing_card?
      @purchase.stripe_customer = current_user.stripe_customer
    end

    if @purchase.save
      km_http_client.record(@purchase.email, "Submit Payment", { "Product Name" => @purchaseable.name, "Order Total" => @purchase.price })
      track_purchase_if_paid(@purchase)
      redirect_to @purchase.success_url
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
    km.record("View Receipt", { "Product Name" => @purchaseable.name })
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
    track_purchase_if_paid(@purchase)
    redirect_to @purchase
  end

  private

  def track_purchase_if_paid(purchase)
    if purchase.paid?
      km_http_client.record(purchase.email, "Purchased", { "Product Name" => purchase.purchaseable.name, "Order Total" => @purchase.price })
    end
  end

  def purchaseable
    if params[:product_id]
      Product.find(params[:product_id])
    elsif params[:section_id]
      Section.find(params[:section_id])
    end
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

  def ensure_paid(purchase)

  end

  def current_purchase
    @current_purchase ||= Purchase.find_by_lookup(params[:id])
  end

  def current_purchaseable
    @current_purchaseable ||= purchaseable
  end

  def track_chrome_screencast_ab_test_completion
    if @purchaseable.name == 'Hidden Secrets of the Chrome Developer Tools'
      finished('new_chrome_cast_description')
    end
  end
end
