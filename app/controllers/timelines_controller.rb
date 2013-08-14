class TimelinesController < ApplicationController
  before_filter :authorize
  layout 'header-only'

  def show
    @timeline = Timeline.new(current_user)
  end
end
