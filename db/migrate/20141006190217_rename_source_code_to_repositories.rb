class RenameSourceCodeToRepositories < ActiveRecord::Migration[4.2]
  def change
    rename_column :plans, :includes_source_code, :includes_repositories
  end
end
