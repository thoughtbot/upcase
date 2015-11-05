module Beta
  class RepliesController < ApplicationController
    before_action :require_login

    def create
      Reply.create!(offer: offer, user: current_user)
      redirect_to practice_path, notice: t("beta.replies.flashes.success")
    end

    private

    def offer
      Offer.find(params[:offer_id])
    end
  end
end
