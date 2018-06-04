class AddIndexesToInvitations < ActiveRecord::Migration
  def change
    add_index :invitations, :sender_id
    add_index :invitations, :recipient_id
  end
end
