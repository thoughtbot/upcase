class AddSlugToCompletions < ActiveRecord::Migration
  def change
    add_column :completions, :slug, :string
  end
end
