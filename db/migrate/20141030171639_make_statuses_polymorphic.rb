class MakeStatusesPolymorphic < ActiveRecord::Migration[4.2]
  def change
    rename_column :statuses, :exercise_id, :completeable_id
    add_column :statuses, :completeable_type, :string
    add_index :statuses, :completeable_type

    change_column_null :statuses, :completeable_type, false, "Exercise"
  end
end
