class ActiveSubscribers
  include Enumerable

  def initialize(relation: Subscription.all)
    @relation = relation
  end

  def each(&block)
    subscribers.each(&block)
  end

  private

  def subscribers
    active_team_subscribers + active_personal_subscribers
  end

  def active_team_subscribers
    active_teams.flat_map(&:users)
  end

  def active_personal_subscribers
    subscriptions_for(plans: Plan.individual).map(&:user)
  end

  def active_teams
    subscriptions_for(plans: Plan.team).map(&:team)
  end

  def subscriptions_for(plans:)
    @relation.
      active.
      where(plan: plans).
      includes(:user).
      includes(team: :users)
  end
end
