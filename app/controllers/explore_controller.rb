class ExploreController < ApplicationController
  before_action :require_login

  def show
    @explore = Explore.new(current_user)

    respond_to do |format|
      format.html
    end
  end
end
