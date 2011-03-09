class RemoveChargifyFromSections < ActiveRecord::Migration
  def self.up
    change_table :sections do |t|
      t.remove :chargify_id
    end
  end

  def self.down
    change_table :sections do |t|
      t.string :chargify_id
    end
  end
end
