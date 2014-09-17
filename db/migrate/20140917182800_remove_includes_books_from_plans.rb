class RemoveIncludesBooksFromPlans < ActiveRecord::Migration
  def change
    remove_column :plans, :includes_books, :boolean
  end
end
