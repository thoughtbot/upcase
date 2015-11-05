module Beta
  class RepliesController < ApplicationController
    before_action :require_login

    def create
      create_reply
      track_reply
      redirect_with_notice
    end

    private

    def create_reply
      offer.reply(user: current_user, accepted: accepted?)
    end

    def track_reply
      analytics.track_replied_to_beta_offer(
        name: offer.name,
        accepted: accepted?,
      )
    end

    def redirect_with_notice
      redirect_to practice_path, notice: notice
    end

    def offer
      Offer.find(params[:offer_id])
    end

    def notice
      if accepted?
        t("beta.replies.flashes.accepted")
      else
        t("beta.replies.flashes.declined")
      end
    end

    def accepted?
      params[:accepted] == "true"
    end
  end
end
