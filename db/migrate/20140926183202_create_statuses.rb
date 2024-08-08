class CreateStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :statuses do |t|
      t.belongs_to :exercise, null: false
      t.belongs_to :user, null: false
      t.string :state, default: "Started", null: false
      t.timestamps
    end

    add_index :statuses, [:exercise_id, :user_id], unique: true
  end
end
