class HomesController < ApplicationController
  def show
    if signed_in?
      redirect_to onboarding_policy.root_path
    else
      @landing_page = true
      @topics = LandingPageTopics.new.topics
      render "subscriptions/new"
    end
  end
end
