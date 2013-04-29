class GithubFulfillment
  def initialize(purchase)
    @purchase = purchase
  end

  def fulfill
    if usernames.present?
      GithubFulfillmentJob.enqueue(team, usernames, @purchase.id)
    end
  end

  def remove
    if usernames.present?
      GithubRemovalJob.enqueue(team, usernames)
    end
  end

  private

  def team
    purchaseable.github_team
  end

  def purchaseable
    @purchase.purchaseable
  end

  def usernames
    users = @purchase.github_usernames || []
    users.map(&:strip).reject(&:blank?).compact
  end
end
