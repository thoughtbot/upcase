class UpdateSqlViews < ActiveRecord::Migration[7.1]
  def change
    replace_view :slugs, version: 2, revert_to_version: 1
  end
end
