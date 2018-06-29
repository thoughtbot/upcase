class CreateInvitations < ActiveRecord::Migration[4.2]
  def change
    create_table :invitations do |table|
      table.string :email, null: false
      table.string :code, null: false
      table.datetime :accepted_at
      table.integer :sender_id, null: false
      table.integer :recipient_id
      table.integer :team_id, null: false
      table.timestamps null: false
    end

    add_index :invitations, :team_id
    add_index :invitations, :code
  end
end
