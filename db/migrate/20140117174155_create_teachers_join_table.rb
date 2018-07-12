class CreateTeachersJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_table :teachers do |t|
      t.belongs_to :user
      t.belongs_to :workshop
    end

    add_index :teachers, [:user_id, :workshop_id], unique: true
  end
end
