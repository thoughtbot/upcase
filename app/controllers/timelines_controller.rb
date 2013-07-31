class TimelinesController < ApplicationController
  before_filter :authorize

  def show
    @completion_weeks = current_user.completions_grouped_by_week
    @notes = current_user.notes
  end
end
