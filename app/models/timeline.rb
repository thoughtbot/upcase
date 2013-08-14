class Timeline
  def initialize(user)
    @user = user
  end

  def has_items?
    items_grouped_by_week.values.present?
  end

  def most_recent_week?(week)
    week == grouped_items.keys.first
  end

  def grouped_items
    if has_items?
      items_grouped_by_week_and_type
    else
      null_week
    end
  end

  private

  attr_reader :user

  def null_week
    { Time.now.beginning_of_week => {} }
  end

  def items_grouped_by_week_and_type
    items_grouped_by_type = {}
    items_grouped_by_week.each do |week, items|
      items_grouped_by_type[week] = items.group_by { |item| item.class.name.tableize.to_sym }
    end
    items_grouped_by_type
  end

  def items_grouped_by_week
    timeline_items.group_by { |item| item.created_at.beginning_of_week }
  end

  def timeline_items
    items = (user.notes + user.completions)
    items.sort! { |item1, item2| item2.created_at <=> item1.created_at }
  end
end
