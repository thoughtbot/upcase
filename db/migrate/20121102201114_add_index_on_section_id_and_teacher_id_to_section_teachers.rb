class AddIndexOnSectionIdAndTeacherIdToSectionTeachers < ActiveRecord::Migration
  def up
    change_table :section_teachers do |t|
      t.remove_index :section_id
      t.remove_index :teacher_id
      t.index [:section_id, :teacher_id], unique: true
    end
  end

  def down
    change_table :section_teachers do |t|
      t.remove_index [:section_id, :teacher_id]
      t.index :section_id
      t.index :teacher_id
    end
  end
end
