class CreateLicensesView < ActiveRecord::Migration
  def change
    create_view :licenses
  end
end
