class EnablePgStatStatements < ActiveRecord::Migration[4.2]
  def change
    enable_extension "pg_stat_statements"
  end
end
