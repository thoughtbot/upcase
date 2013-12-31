class GithubFulfillment
  def initialize(purchase)
    @purchase = purchase
  end

  def fulfill
    GithubFulfillmentJob.enqueue(team, usernames, @purchase.id)
  end

  def remove
    GithubRemovalJob.enqueue(team, usernames)
  end

  private

  def team
    purchaseable.github_team
  end

  def purchaseable
    @purchase.purchaseable
  end

  def usernames
    @purchase.github_usernames
  end
end
