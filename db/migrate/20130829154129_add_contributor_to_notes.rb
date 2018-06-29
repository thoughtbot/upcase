class AddContributorToNotes < ActiveRecord::Migration[4.2]
  def up
    add_column :notes, :contributor_id, :integer
    execute <<-SQL
      UPDATE notes
      SET contributor_id = user_id
    SQL
    change_column_null :notes, :contributor_id, false
  end

  def down
    remove_column :notes, :contributor_id
  end
end
