class GithubFulfillment
  def initialize(purchase)
    @purchase = purchase
  end

  def fulfill
    if fulfilled_with_github?
      GithubFulfillmentJob.enqueue(team, usernames, @purchase.id)
    end
  end

  def remove
    if fulfilled_with_github?
      GithubRemovalJob.enqueue(team, usernames)
    end
  end

  private

  def fulfilled_with_github?
    team.present?
  end

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
