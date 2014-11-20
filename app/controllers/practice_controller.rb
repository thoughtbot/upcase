class PracticeController < ApplicationController
  before_action :authorize

  def show
    @practice = Practice.new(current_user)
  end
end
