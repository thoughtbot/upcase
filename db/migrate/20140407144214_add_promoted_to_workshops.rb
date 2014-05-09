class AddPromotedToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :promoted, :boolean, default: false, null: false
  end
end
