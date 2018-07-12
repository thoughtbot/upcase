class RemoveIncludesBooksFromPlans < ActiveRecord::Migration[4.2]
  def change
    remove_column :plans, :includes_books, :boolean
  end
end
