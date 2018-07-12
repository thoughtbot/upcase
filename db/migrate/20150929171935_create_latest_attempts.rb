class CreateLatestAttempts < ActiveRecord::Migration[4.2]
  def change
    create_view :latest_attempts
  end
end
