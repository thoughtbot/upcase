class TimelinesController < ApplicationController
  before_filter :authorize

  def show
    @timeline_items_by_week = current_user.grouped_timeline_items
  end
end
