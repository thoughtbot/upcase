class PracticeController < ApplicationController
  before_action :require_login

  def show
    @practice = Practice.new(trails)
  end

  private

  def trails
    TrailWithProgressQuery.new(
      TrailsForPracticePageQuery.new,
      user: current_user,
    )
  end
end
