class ChangePublicColumnDefaultInCourses < ActiveRecord::Migration
  def self.up
    change_column_default :courses, :public, true
    execute "UPDATE courses SET public='true';"
  end

  def self.down
    change_column_default :courses, :public, false
  end
end
