class RenameSourceCodeToRepositories < ActiveRecord::Migration
  def change
    rename_column :plans, :includes_source_code, :includes_repositories
  end
end
