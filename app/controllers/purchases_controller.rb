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
    @purchase.coupon = Coupon.find_by_id_and_active(params[:coupon_id], true) unless params[:coupon_id].blank?
    if params[:use_existing_card] == "on"
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
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.find_by_lookup!(params[:id])
    redirect_if_unpaid
  end

  def paypal
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.find_by_lookup!(params[:id])
    @purchase.complete_paypal_payment!(params[:token], params[:PayerID])
    redirect_to product_purchase_path(@purchase.product, @purchase) 
  end

  def watch
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.find_by_lookup!(params[:id])
    redirect_if_unpaid
  end

  private

  def retrieve_active_card
    if current_user && current_user.stripe_customer
      Stripe::Customer.retrieve(current_user.stripe_customer)["active_card"]
    end
  end

  def redirect_if_unpaid
    if !@purchase.paid?
      redirect_to product_path(@product)
    end
  end

  def track_chrome_screencast_ab_test_completion
    if @product.name == "Hidden Secrets of the Chrome Developer Tools"
      finished('new_chrome_cast_description')
    end
  end
end
