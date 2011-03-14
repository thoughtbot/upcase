class AdminController < ApplicationController
  layout 'admin'

  before_filter :must_be_admin

  protected

  def must_be_admin
    unless current_user && current_user.admin?
      flash[:error] = 'You do not have permission to view that page.'
      redirect_to root_url
    end
  end
end
