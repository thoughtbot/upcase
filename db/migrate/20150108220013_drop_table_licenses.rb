class DropTableLicenses < ActiveRecord::Migration[4.2]
  def change
    drop_table :licenses
  end
end
