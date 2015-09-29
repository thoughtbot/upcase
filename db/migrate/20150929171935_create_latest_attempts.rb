class CreateLatestAttempts < ActiveRecord::Migration
  def change
    create_view :latest_attempts
  end
end
