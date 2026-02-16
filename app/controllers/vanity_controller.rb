class VanityController < ApplicationController
  before_action :deprecated
  before_action :must_be_admin

  include Vanity::Rails::Dashboard

  layout false

  private

  def deprecated
    warning = "#{self.class.name}##{action_name} is deprecated."
    flash[:error] = "WARNING: #{warning}"
    ActiveSupport::Deprecation.new.warn(warning)
  end

  def must_be_admin
    unless current_user&.admin?
      flash[:error] = "You do not have permission to view that page."
      redirect_to root_url
    end
  end
end
