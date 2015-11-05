class PracticeController < ApplicationController
  before_action :require_login

  def show
    @practice = Practice.new(
      trails: trails,
      beta_offers: beta_offers,
    )
  end

  private

  def trails
    TrailWithProgressQuery.new(
      TrailsForPracticePageQuery.new,
      user: current_user,
    )
  end

  def beta_offers
    Beta::Offer.most_recent_first.visible_to(current_user)
  end
end
