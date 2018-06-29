class RemoveAudiences < ActiveRecord::Migration[4.2]
  def up
    remove_column :workshops, :audience_id
    drop_table :audiences
  end

  def down
    create_table :audiences do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_column :workshops, :audience_id, :integer
    add_index :workshops, :audience_id
  end
end
