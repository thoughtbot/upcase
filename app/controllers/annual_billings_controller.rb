class AnnualBillingsController < ApplicationController
  before_action :require_login
  before_action :validate_upgrade_eligibility

  def new
    @annualized_payment = current_user.annualized_payment
    @discounted_annual_payment = current_user.discounted_annual_payment
    @annual_plan_sku = current_user.annual_plan_sku
  end

  private

  def validate_upgrade_eligibility
    unless current_user_is_eligible_for_annual_upgrade?
      redirect_to root_path
    end
  end
end
