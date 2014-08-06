class RemoveNotes < ActiveRecord::Migration
  def up
    drop_table :notes
  end

  def down
    create_table :notes do |t|
      t.references :user, index: true
      t.text :body
      t.timestamps
    end
  end
end
