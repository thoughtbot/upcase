class InitializeActsAsListForCourses < ActiveRecord::Migration[4.2]
  def self.up
    execute <<-SQL
      CREATE SEQUENCE list_import START 1;
      UPDATE courses SET position = nextval('list_import');
      DROP SEQUENCE list_import;
    SQL
  end

  def self.down
  end
end
