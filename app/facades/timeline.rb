class Timeline
  def initialize(user)
    @user = user
  end

  def has_items?
    grouped_items.values.present?
  end

  def grouped_items
    timeline_items_grouped_by_item_type = {}
    timeline_items_grouped_by_week.each do |week, items|
      items.sort_by! { |item| item.created_at }
      items.reverse!
      timeline_items_grouped_by_item_type[week] = items.group_by do |item|
        item.class.name.tableize.to_sym
      end
    end
    timeline_items_grouped_by_item_type
  end

  private

  attr_reader :user

  def timeline_items_grouped_by_week
    (user.notes + user.completions).group_by { |item| item.created_at.beginning_of_week }
  end
end
