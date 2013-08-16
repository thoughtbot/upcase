class Timeline
  def initialize(user)
    @user = user
  end

  def has_items?
    timeline_items.values.present?
  end

  def most_recent_week?(week)
    week == grouped_items.keys.first
  end

  def grouped_items
    if has_items?
      timeline_items
    else
      null_week
    end
  end

  private

  attr_reader :user

  def null_week
    { Time.now.beginning_of_week => {} }
  end

  def timeline_items
    @timeline_items ||= items_grouped_by_week_and_type
  end

  def items_grouped_by_week_and_type
    items_grouped_by_week_and_type = {}
    items_grouped_by_week.each do |week, items|
      items_grouped_by_week_and_type[week] = items.group_by { |item| item.class.name.tableize.to_sym }
    end
    items_grouped_by_week_and_type
  end

  def items_grouped_by_week
    items = (user.notes + user.completions).sort! { |item1, item2| item2.created_at <=> item1.created_at }
    items.group_by { |item| item.created_at.beginning_of_week }
  end
end
