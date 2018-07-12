class CreateSteps < ActiveRecord::Migration[4.2]
  def change
    create_table :steps do |t|
      t.references :trail, null: false
      t.references :exercise, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end

    add_index :steps, :trail_id
  end
end
