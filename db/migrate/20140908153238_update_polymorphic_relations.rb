class UpdatePolymorphicRelations < ActiveRecord::Migration[4.2]
  def up
    update_polymorphic_references :classifications,
      :classifiable_type,
      "Workshop",
      "VideoTutorial"

    update_polymorphic_references :licenses,
      :licenseable_type,
      "Workshop",
      "VideoTutorial"

    update_polymorphic_references :videos,
      :watchable_type,
      "Workshop",
      "VideoTutorial"
  end

  def down
    update_polymorphic_references :classifications,
      :classifiable_type,
      "VideoTutorial",
      "Workshop"

    update_polymorphic_references :licenses,
      :licenseable_type,
      "VideoTutorial",
      "Workshop"

    update_polymorphic_references :videos,
      :watchable_type,
      "VideoTutorial",
      "Workshop"
  end

  private

  def update_polymorphic_references(table, column, previous, new)
    say_with_time "Changing #{previous} to #{new} on #{table}.#{column}" do
      connection.update(<<-SQL)
        UPDATE #{table}
        SET #{column} = '#{new}'
        WHERE #{column} = '#{previous}'
      SQL
    end
  end
end
