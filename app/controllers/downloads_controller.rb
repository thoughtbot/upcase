class DownloadsController < ApplicationController
  def show
    @purchase = Purchase.find_by_lookup!(params[:purchase_id])
    @purchaseable = @purchase.purchaseable

    send_data @purchaseable.file(params[:format]), 
      filename: "#{@purchaseable.filename(params[:format])}"
  end
end
