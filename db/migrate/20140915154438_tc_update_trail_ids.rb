class TcUpdateTrailIds < ActiveRecord::Migration
  def up
    execute "UPDATE completions SET slug = 'test-driven-development' WHERE (slug = 'test-driven+development')"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
