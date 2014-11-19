class AnnualBillingsController < ApplicationController
  before_filter :authorize

  def new
    @annualized_payment = current_user.annualized_payment
    @discounted_annual_payment = current_user.discounted_annual_payment
  end

  def create
    AnnualBillingMailer.notification(current_user).deliver

    redirect_to(
      practice_path,
      notice: "Thanks! We'll upgrade your account to annual billing."
    )
  end
end
