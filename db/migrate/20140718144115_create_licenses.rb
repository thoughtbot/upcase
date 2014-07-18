class CreateLicenses < ActiveRecord::Migration
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
  end
end
