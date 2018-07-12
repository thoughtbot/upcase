class AddEditUrlToExercises < ActiveRecord::Migration[4.2]
  def up
    add_column :exercises, :edit_url, :string

    update <<-SQL.squish
      UPDATE exercises
      SET edit_url = regexp_replace(
        url,
        '/exercises/(.+)$',
        '/admin/exercises/\\1/edit'
      )
    SQL
  end

  def down
    remove_column :exercises, :edit_url
  end
end
