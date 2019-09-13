class PracticeController < ApplicationController
  def show
    @practice = Practice.new(trails: trails)
  end

  private

  def trails
    TrailWithProgressQuery.new(
      TrailsForPracticePageQuery.new,
      user: current_user,
    )
  end
end
