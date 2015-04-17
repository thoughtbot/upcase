class DontMakeNewPlansFeatured < ActiveRecord::Migration
  def change
    change_column_default :plans, :featured, false
  end
end
