class RenameTrails < ActiveRecord::Migration
  def change
    rename_table :trails, :legacy_trails
  end
end
