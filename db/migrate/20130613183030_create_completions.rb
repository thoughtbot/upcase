class CreateCompletions < ActiveRecord::Migration
  def change
    create_table :completions do |t|
      t.string :trail_object_id
      t.string :trail_name
      t.belongs_to :user

      t.timestamps
    end
  end
end
