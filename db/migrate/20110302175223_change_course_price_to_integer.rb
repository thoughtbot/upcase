class ChangeCoursePriceToInteger < ActiveRecord::Migration[4.2]
  def self.up
    add_column :courses, :price_int, :integer, null: true, default: nil
    execute <<-SQL
      UPDATE courses SET price_int = price::integer;
    SQL
    remove_column :courses, :price
    rename_column :courses, :price_int, :price
  end

  def self.down
    add_column :courses, :price_text, :string, null: false, default: ""
    execute <<-SQL
      UPDATE courses SET price_text = price::text;
    SQL
    remove_column :courses, :price
    rename_column :courses, :price_text, :price
  end
end
