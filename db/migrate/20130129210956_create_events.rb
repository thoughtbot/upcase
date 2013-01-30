class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.belongs_to :workshop, null: false
      t.string :title, null: false
      t.string :time, null: false
      t.integer :occurs_on_day, default: 0, null: false
      t.timestamps
    end
  end
end
