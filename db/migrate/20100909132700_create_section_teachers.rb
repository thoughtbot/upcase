class CreateSectionTeachers < ActiveRecord::Migration
  def self.up
    create_table :section_teachers do |t|
      t.belongs_to :section, :teacher
      t.timestamps
    end
    add_index :section_teachers, :section_id
    add_index :section_teachers, :teacher_id
  end

  def self.down
    drop_table :section_teachers
  end
end
