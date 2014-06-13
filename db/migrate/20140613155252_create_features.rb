class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :key, null: false
      t.references :plan, polymorphic: true, null: false

      t.timestamps null: false
    end

    add_index :features, [:plan_id, :plan_type]
    add_index :features, :key
  end
end
