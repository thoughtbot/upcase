class HomesController < ApplicationController
  def show
    if signed_in?
      redirect_to dashboard_path
    else
      redirect_to subscribe_path
    end
  end
end
