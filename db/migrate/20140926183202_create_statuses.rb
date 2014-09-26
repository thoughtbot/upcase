class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.belongs_to :exercise
      t.belongs_to :user
      t.string     :state, default: "Started"
      t.timestamps
    end

    add_index :statuses, [:exercise_id, :user_id], unique: true
  end
end
