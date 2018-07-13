module TeamPlansHelper
  def team_page?
    @team_page.present?
  end

  def next_payment_date(subscription)
    subscription.
      next_payment_on.
      to_s(:simple)
  end
end
