class CreateAudiences < ActiveRecord::Migration
  def self.up
    create_table :audiences do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_column :courses, :audience_id, :integer
    add_index :courses, :audience_id
  end

  def self.down
    remove_column :courses, :audience_id

    drop_table :audiences
  end
end
