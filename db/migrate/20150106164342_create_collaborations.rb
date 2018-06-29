class CreateCollaborations < ActiveRecord::Migration[4.2]
  def up
    create_table :collaborations do |table|
      table.integer :repository_id, null: false
      table.integer :user_id, null: false
      table.timestamps null: false
    end

    connection.insert(<<-SQL)
      WITH repository_licenses AS (
        DELETE FROM licenses
        USING products
        WHERE licenses.licenseable_id = products.id
          AND licenses.licenseable_type = 'Product'
          AND products.type = 'Repository'
        RETURNING
          licenses.licenseable_id,
          licenses.user_id,
          licenses.created_at,
          licenses.updated_at
      )
      INSERT INTO collaborations
        (repository_id, user_id, created_at, updated_at)
      SELECT * FROM repository_licenses
    SQL

    add_index :collaborations, [:repository_id, :user_id], unique: true
  end

  def down
    connection.insert(<<-SQL)
      WITH deleted_collaborations AS (
        DELETE FROM collaborations
        RETURNING *
      )
      INSERT INTO licenses
        (licenseable_id, licenseable_type, user_id, created_at, updated_at)
      SELECT repository_id, 'Product', user_id, created_at, updated_at
      FROM deleted_collaborations
    SQL

    drop_table :collaborations
  end
end
