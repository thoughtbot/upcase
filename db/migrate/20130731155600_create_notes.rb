class CreateNotes < ActiveRecord::Migration[4.2]
  def change
    create_table :notes do |t|
      t.references :user, index: true
      t.text :body
      t.timestamps
    end
  end
end
