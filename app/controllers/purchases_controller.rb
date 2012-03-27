class PurchasesController < ApplicationController
  def new
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.build(:variant => params[:variant])
  end

  def create
    @product = Product.find(params[:product_id])
    @purchase = @product.purchases.build(params[:purchase])
    @purchase.coupon = Coupon.find_by_id_and_active(params[:coupon_id], true) unless params[:coupon_id].blank?

    if @purchase.save
      if @purchase.stripe?
        redirect_to product_purchase_path(@purchase.product, @purchase)
      else
        redirect_to @purchase.paypal_url
      end
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
end
