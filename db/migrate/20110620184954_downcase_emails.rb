class DowncaseEmails < ActiveRecord::Migration[4.2]
  def self.up
    update "update users set email = LOWER(email)"
  end

  def self.down
  end
end
