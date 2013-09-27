class HomesController < ApplicationController
  def show
    if signed_in?
      redirect_to dashboard_path
    else
      redirect_to prime_path
    end
  end
end
