class CreateFeatureRecordsForPlanBooleans < ActiveRecord::Migration
  def up
    create_features_for_workshops
    create_features_for_mentoring
  end

  def down
    destroy_features
  end

  private

  def create_features_for_workshops
    create_features(
      'workshops',
      'includes_workshops',
      'IndividualPlan',
      'individual_plans'
    )
    create_features(
      'workshops',
      'includes_workshops',
      'Teams::TeamPlan',
      'team_plans'
    )
  end

  def create_features_for_mentoring
    create_features(
      'mentoring',
      'includes_mentor',
      'IndividualPlan',
      'individual_plans'
    )
    create_features(
      'mentoring',
      'includes_mentor',
      'Teams::TeamPlan',
      'team_plans'
    )
  end

  def create_features(feature_key, column, plan_type, plan_table)
    insert <<-SQL
      INSERT INTO features
      (key, plan_id, plan_type, created_at, updated_at)
      (
        SELECT
          '#{feature_key}', id, '#{plan_type}', now(), now()
          from #{plan_table}
          where #{column}
      )
    SQL
  end

  def destroy_features
    delete "DELETE FROM features where plan_type = 'IndividualPlan'"
    delete "DELETE FROM features where plan_type = 'TeamPlan'"
  end
end
