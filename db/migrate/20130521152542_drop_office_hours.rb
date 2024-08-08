class DropOfficeHours < ActiveRecord::Migration[4.2]
  def up
    drop_table :office_hours
    add_column :workshops, :office_hours, :string, null: false, default: ""
  end

  def down
    remove_column :workshops, :office_hours
    create_table "office_hours", force: true do |t|
      t.integer "workshop_id", null: false
      t.string "title", null: false
      t.string "time", null: false
      t.integer "occurs_on_week_day", default: 0, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "occurs_in_week"
    end
  end
end
