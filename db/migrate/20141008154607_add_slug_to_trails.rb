class AddSlugToTrails < ActiveRecord::Migration[4.2]
  def up
    add_column :trails, :slug, :string
    generate_slug :trails, :name, :slug
    change_column_null :trails, :slug, false
    add_index :trails, :slug, unique: true
  end

  def down
    remove_column :trails, :slug
  end

  private

  def generate_slug(table, source, target)
    say_with_time "Generating slugs for existing #{table}" do
      select_rows("SELECT id, #{source} FROM #{table}").each do |(id, value)|
        slug = value.downcase.parameterize.gsub(/[^\w-]/, "")
        update("UPDATE #{table} SET #{target} = '#{slug}' WHERE id = #{id}")
      end
    end
  end
end
