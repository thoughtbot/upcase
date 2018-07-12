class EnforceZerioPricesOnProducts < ActiveRecord::Migration[4.2]
  def up
    change_column_default :products, :individual_price, 0
    change_column_default :products, :company_price, 0
    change_column_null :products, :individual_price, false
    change_column_null :products, :company_price, false
  end

  def down
    change_column_default :products, :individual_price, nil
    change_column_default :products, :company_price, nil
    change_column_null :products, :individual_price, true
    change_column_null :products, :company_price, true
  end
end
