class Show < Product
  THE_WEEKLY_ITERATION = 'The Weekly Iteration'

  def self.the_weekly_iteration
    where(name: THE_WEEKLY_ITERATION).first
  end
end
