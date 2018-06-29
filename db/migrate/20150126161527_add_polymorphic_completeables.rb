class AddPolymorphicCompleteables < ActiveRecord::Migration[4.2]
  def change
    rename_column :steps, :exercise_id, :completeable_id
    add_column :steps, :completeable_type, :string
    update <<-SQL
      UPDATE steps SET completeable_type='Exercise'
    SQL
    change_column_null :steps, :completeable_type, false
  end
end
