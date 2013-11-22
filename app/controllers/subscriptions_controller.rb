class SubscriptionsController < ApplicationController
  before_filter :assign_mentor, only: [:new, :edit]

  def new
    @plans = IndividualPlan.featured.active.ordered
    @team_plans = TeamPlan.featured.ordered
  end

  def edit
    @plans = IndividualPlan.featured.active.ordered
  end

  def update
    plan = IndividualPlan.find_by_sku!(params[:plan_id])
    current_user.subscription.change_plan(plan)
    redirect_to my_account_path, notice: I18n.t('subscriptions.flashes.change.success')
  end

  private

  def assign_mentor
    @mentor = Mentor.find_or_sample(cookies[:mentor_id])

    if cookies[:mentor_id].blank?
      cookies[:mentor_id] ||= @mentor.id
    end
  end
end
