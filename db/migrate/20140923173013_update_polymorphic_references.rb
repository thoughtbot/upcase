class UpdatePolymorphicReferences < ActiveRecord::Migration
  def up
    update_references_from(:classifications, :classifiable_type)
    update_references_from(:downloads, :purchaseable_type)
    update_references_from(:licenses, :licenseable_type)
    update_references_from(:products, :type)
  end

  def down
  end

  private

  def update_references_from(table, type_column)
    say_with_time "Converting Screencasts into VideoTutorials (#{table}.#{type_column})" do
      # When referenced as Products
      update <<-SQL
        UPDATE #{table}
          SET #{type_column} = 'VideoTutorial'
          WHERE #{type_column} = 'Screencast'
      SQL
    end
  end
end
