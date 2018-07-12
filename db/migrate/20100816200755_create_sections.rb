class CreateSections < ActiveRecord::Migration[4.2]
  def self.up
    create_table :sections do |t|
      t.belongs_to :course
      t.date :starts_on, :ends_on

      t.timestamps
    end
    add_index :sections, :course_id
  end

  def self.down
    drop_table :sections
  end
end
