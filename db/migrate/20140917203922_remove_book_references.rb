class RemoveBookReferences < ActiveRecord::Migration[4.2]
  def up
    remove_book_references_from(:classifications, :classifiable_type, :classifiable_id)
    remove_book_references_from(:downloads, :purchaseable_type, :purchaseable_id)
    remove_book_references_from(:licenses, :licenseable_type, :licenseable_id)
    delete("DELETE FROM products WHERE type = 'Book'")
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def remove_book_references_from(table, type_column, id_column)
    say_with_time "Removing Book references from #{table}.#{type_column}" do
      # When referenced as Products
      delete <<-SQL
        DELETE FROM #{table}
          USING products
          WHERE products.type = 'Book'
            AND (#{type_column} = products.type OR #{type_column} = 'Product')
            AND #{id_column} = products.id
      SQL
    end
  end
end
