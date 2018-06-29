class CreateCourses < ActiveRecord::Migration[4.2]
  def self.up
    create_table :courses do |t|
      t.string :name, :price, :location, :null => false, :default => ''
      t.text :description, :terms_of_service, :reminder_email
      t.time :start_at, :stop_at
      t.integer :maximum_students
      t.boolean :public, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
