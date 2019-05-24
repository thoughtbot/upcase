class RemoveCollaborations < ActiveRecord::Migration[5.2]
  def change
    drop_table :collaborations
  end
end
