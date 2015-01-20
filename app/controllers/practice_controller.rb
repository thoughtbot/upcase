class PracticeController < ApplicationController
  before_action :require_login

  def show
    @practice = Practice.new(current_user)
  end
end
