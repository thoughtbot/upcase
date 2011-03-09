class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :code
      t.integer :percentage

      t.timestamps
    end

    add_index :coupons, :code
  end

  def self.down
    drop_table :coupons
  end
end
