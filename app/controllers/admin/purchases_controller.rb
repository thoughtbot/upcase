class Admin::PurchasesController < AdminController
  def index
    respond_to do |format|
      format.html
      format.csv do
        @purchases = Purchase.from_month(Date.parse(params[:date]))
        render :csv => @purchases, :fields => [:id, :paid, :payment_method, :payment_transaction_id, :product_name, :price, :created_at]
      end
    end
  end
end
