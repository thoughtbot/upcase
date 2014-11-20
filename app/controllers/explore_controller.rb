class ExploreController < ApplicationController
  before_action :authorize

  def show
    @explore = Explore.new(current_user)
  end
end
