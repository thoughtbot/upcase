class UpdateProductTypeOnProducts < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE products
      SET product_type = 'book'
      WHERE product_type = 'book and example app'
    SQL

    execute <<-SQL
      UPDATE products
      SET product_type = 'video'
      WHERE product_type = 'screencast'
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
