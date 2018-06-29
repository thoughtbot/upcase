class CreateTeamPlan < ActiveRecord::Migration[4.2]
  def change
    create_table :team_plans do |t|
      t.string :sku, null: false
      t.string :name, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
