class Repository < Product
  validates :github_team, presence: true
  validates :github_url, presence: true

  def included_in_plan?(plan)
    plan.has_feature?(:source_code)
  end
end
