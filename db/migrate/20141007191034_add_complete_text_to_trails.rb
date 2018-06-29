class AddCompleteTextToTrails < ActiveRecord::Migration[4.2]
  def up
    add_column :trails, :complete_text, :string
    change_column_null :trails, :complete_text, false, "Nice work!"
  end

  def down
    remove_column :trails, :complete_text
  end
end
