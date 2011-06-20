class DowncaseEmails < ActiveRecord::Migration
  def self.up
    update "update users set email = LOWER(email)"
  end

  def self.down
  end
end
