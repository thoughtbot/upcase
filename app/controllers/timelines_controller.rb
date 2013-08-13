class TimelinesController < ApplicationController
  before_filter :authorize

  def show
    @timeline = Timeline.new(current_user)
  end
end
