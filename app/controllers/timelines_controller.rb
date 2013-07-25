class TimelinesController < ApplicationController
  before_filter :authorize

  def show
    @completions = current_user.completions.all
  end
end
