class TimelinesController < ApplicationController
  before_filter :authorize

  def show
    @items_by_week = current_user.grouped_timeline_items
  end
end
