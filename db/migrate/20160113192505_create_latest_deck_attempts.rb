class CreateLatestDeckAttempts < ActiveRecord::Migration
  def change
    create_view :latest_deck_attempts
  end
end
