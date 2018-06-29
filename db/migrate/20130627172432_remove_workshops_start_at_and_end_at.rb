class RemoveWorkshopsStartAtAndEndAt < ActiveRecord::Migration[4.2]
  def up
    remove_column :workshops, :start_at
    remove_column :workshops, :stop_at
  end

  def down
    add_column :workshops, :stop_at, :time
    add_column :workshops, :start_at, :time
  end
end
