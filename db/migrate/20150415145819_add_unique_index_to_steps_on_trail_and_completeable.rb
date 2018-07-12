class AddUniqueIndexToStepsOnTrailAndCompleteable < ActiveRecord::Migration[4.2]
  def up
    add_index :steps,
              [:trail_id, :completeable_id, :completeable_type],
              name: "index_steps_on_trail_and_completeable_unique",
              unique: true
    remove_index :steps, :trail_id
  end

  def down
    add_index :steps, :trail_id
    remove_index :steps, name: "index_steps_on_trail_and_completeable_unique"
  end
end
