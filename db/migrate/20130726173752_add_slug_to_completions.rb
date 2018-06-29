class AddSlugToCompletions < ActiveRecord::Migration[4.2]
  def change
    add_column :completions, :slug, :string
  end
end
