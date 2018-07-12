class CreateTeams < ActiveRecord::Migration[4.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.integer :team_plan_id

      t.timestamps
    end
  end
end
