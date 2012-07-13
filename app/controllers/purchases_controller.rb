class PurchasesController < ApplicationController
  def new
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.build(variant: params[:variant])
    track_chrome_screencast_ab_test_completion
  end

  def create
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.build(params[:purchase])
    @purchase.coupon = Coupon.find_by_id_and_active(params[:coupon_id], true) unless params[:coupon_id].blank?

    if @purchase.save
      redirect_to @purchase.success_url
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.find_by_lookup!(params[:id])
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
  end

  private

  def track_chrome_screencast_ab_test_completion
    if @product.name == "Hidden Secrets of the Chrome Developer Tools"
      finished('new_chrome_cast_description')
    end
  end
end
