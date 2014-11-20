class ExploreController < ApplicationController
  def show
    @explore = Explore.new(current_user)
  end
end
