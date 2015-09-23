class PracticeController < ApplicationController
  before_action :require_login

  def show
    @practice = Practice.new(trails)
  end

  private

  def trails
    TrailsForPracticePageQuery.
      call.
      map { |trail| TrailWithProgress.new(trail, user: current_user) }
  end
end
