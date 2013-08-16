module TimelinesHelper
  def week_title(week)
    "Week of #{week.strftime('%b %-d')} - #{week.end_of_week.strftime('%b %-d')}"
  end
end
