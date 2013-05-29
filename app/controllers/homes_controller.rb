class HomesController < ApplicationController
  def show
    if signed_in?
      redirect_to products_path
    else
      redirect_to prime_path
    end
  end
end
