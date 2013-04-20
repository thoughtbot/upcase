class DownloadsController < ApplicationController
  def show
    @purchase = Purchase.find_by_lookup!(params[:purchase_id])
    @purchaseable = @purchase.purchaseable

    contents = @purchaseable.file(params[:format])

    if contents.present?
      send_data contents, filename: "#{@purchaseable.filename(params[:format])}"
    else
      render nothing: true, status: :not_found
    end
  end
end
