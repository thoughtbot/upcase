class CreateCompletions < ActiveRecord::Migration[4.2]
  def change
    create_table :completions do |t|
      t.string :trail_object_id
      t.string :trail_name
      t.belongs_to :user

      t.timestamps
    end

    add_index :completions, :user_id
    add_index :completions, :trail_object_id
  end
end
