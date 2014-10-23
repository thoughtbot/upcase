class CompletedTrailsController < ApplicationController
  def index
    @trails = Trail.completed_for(current_user)
  end
end
