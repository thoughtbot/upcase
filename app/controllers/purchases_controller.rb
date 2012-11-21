class PurchasesController < ApplicationController
  def new
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.build(variant: params[:variant])
    @purchase.defaults_from_user(current_user)
    @active_card = retrieve_active_card
    track_chrome_screencast_ab_test_completion
  end

  def create
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.build(params[:purchase])
    @purchase.user = current_user

    if use_coupon?
      @purchase.coupon = Coupon.active.find_by_id(params[:coupon_id])
    end

    if use_existing_card?
      @purchase.stripe_customer = current_user.stripe_customer
    end

    if @purchase.save
      redirect_to @purchase.success_url
    else
      @active_card = retrieve_active_card
      render :new
    end
  end

  def show
    @purchase = current_purchase
    @product = current_product
    ensure_purchase_paid
  end

  def watch
    @product = current_product
    @purchase = current_purchase
    ensure_purchase_paid and return

    if @product.videos.one?
      redirect_to [@product, @purchase, @product.videos.first]
    else
      redirect_to [@product, @purchase, :videos]
    end
  end

  def paypal
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.find_by_lookup!(params[:id])
    @purchase.complete_paypal_payment!(params[:token], params[:PayerID])

    redirect_to product_purchase_path(@purchase.product, @purchase)
  end

  private

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

  def ensure_purchase_paid
    unless current_purchase.paid?
      redirect_to product_path(current_product)
    end
  end

  def current_purchase
    @current_purchase ||= current_product.purchases.find_by_lookup(params[:id])
  end

  def current_product
    @current_product ||= Product.find(params[:product_id])
  end

  def track_chrome_screencast_ab_test_completion
    if @product.name == 'Hidden Secrets of the Chrome Developer Tools'
      finished('new_chrome_cast_description')
    end
  end
end
