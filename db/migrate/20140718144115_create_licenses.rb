class CreateLicenses < ActiveRecord::Migration[4.2]
  def change
    create_table :licenses do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :licenseable, polymorphic: true, null: false
      t.timestamps
    end
    add_index(
      :licenses,
      [:user_id, :licenseable_id, :licenseable_type],
      unique: true,
      name: :index_licenses_on_user_id_and_licenseable
    )
    insert(<<-SQL)
      INSERT INTO licenses
        (user_id, licenseable_id, licenseable_type, created_at, updated_at)
        (SELECT DISTINCT ON (user_id, purchaseable_id, purchaseable_type)
            user_id, purchaseable_id, purchaseable_type, created_at, updated_at
            FROM purchases
            WHERE
              (payment_method='stripe' OR
                payment_method='paypal' OR
                payment_method='subscription') AND
              paid = true AND
              user_id IS NOT NULL AND
              purchaseable_id IS NOT NULL AND
              purchaseable_type IS NOT NULL AND
              purchaseable_type NOT LIKE '%Plan'
        )
    SQL
  end
end
