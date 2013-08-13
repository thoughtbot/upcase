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
    if items_grouped_by_week.keys.empty?
      null_week
    else
      items_grouped_by_week_and_type
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
      items.sort! { |item1, item2| item2.created_at <=> item1.created_at }
      items_grouped_by_type[week] = items.group_by { |item| item.class.name.tableize.to_sym }
    end
    items_grouped_by_type
  end

  def items_grouped_by_week
    (user.notes + user.completions).group_by { |item| item.created_at.beginning_of_week }
  end
end
