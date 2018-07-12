class AddPromotedToWorkshops < ActiveRecord::Migration[4.2]
  def change
    add_column :workshops, :promoted, :boolean, default: false, null: false
  end
end
