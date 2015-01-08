class DropTableLicenses < ActiveRecord::Migration
  def change
    drop_table :licenses
  end
end
