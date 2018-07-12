class DontMakeNewPlansFeatured < ActiveRecord::Migration[4.2]
  def change
    change_column_default :plans, :featured, false
  end
end
