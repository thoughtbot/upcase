class UpdatePlanType < ActiveRecord::Migration[4.2]
  def up
    update_type :subscriptions, :plan_type, "Teams::TeamPlan", "TeamPlan"
  end

  def down
    update_type :subscriptions, :plan_type, "TeamPlan", "Teams::TeamPlan"
  end

  private

  def update_type(table, column, previous, new)
    say_with_time "Changing #{previous} to #{new} on #{table}.#{column}" do
      connection.update(<<-SQL)
        UPDATE #{table}
        SET #{column} = '#{new}'
        WHERE #{column} = '#{previous}'
      SQL
    end
  end
end
