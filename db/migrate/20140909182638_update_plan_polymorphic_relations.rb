class UpdatePlanPolymorphicRelations < ActiveRecord::Migration[4.2]
  def up
    update_polymorphic_references :checkouts,
                                  :subscribeable_type,
                                  "IndividualPlan",
                                  "Plan"
    update_team_plan_ids(:checkouts, :subscribeable)

    update_polymorphic_references :subscriptions,
                                  :plan_type,
                                  "IndividualPlan",
                                  "Plan"
    update_team_plan_ids(:subscriptions, :plan)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def update_polymorphic_references(table, column, previous, new)
    say_with_time "Changing #{previous} to #{new} on #{table}.#{column}" do
      connection.update(<<-SQL)
        UPDATE #{table}
        SET #{column} = '#{new}'
        WHERE #{column} = '#{previous}'
      SQL
    end
  end

  def update_team_plan_ids(table, column_prefix)
    # Set new foreign key from team_plans.id to plans.id
    execute(<<-SQL)
      UPDATE #{table} SET #{column_prefix}_type = 'Plan', #{column_prefix}_id =
        (SELECT id FROM plans
          WHERE includes_team = TRUE
          AND plans.name =
            (SELECT name FROM team_plans
              WHERE team_plans.id = #{table}.#{column_prefix}_id))
        WHERE #{column_prefix}_type = 'TeamPlan'
          OR #{column_prefix}_type = 'Teams::TeamPlan'
    SQL
  end
end
