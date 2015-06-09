class HomesController < ApplicationController
  def show
    if signed_in?
      redirect_to onboarding_policy.root_path
    else
      redirect_to join_path
    end
  end
end
