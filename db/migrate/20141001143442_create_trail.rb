class CreateTrail < ActiveRecord::Migration
  def change
    create_table :trails do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
