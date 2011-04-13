class RemoveResources < ActiveRecord::Migration
  def self.up
    drop_table :resources
  end

  def self.down
    create_table "resources", :force => true do |t|
      t.integer "course_id"
      t.string  "name"
      t.string  "url"
    end
    add_index "resources", ["course_id"], :name => "index_resources_on_course_id"
  end
end
