class CreateTrail < ActiveRecord::Migration[4.2]
  def change
    create_table :trails do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
