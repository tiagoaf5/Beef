class AddIndexToPendingGamesNotifications < ActiveRecord::Migration
  def change
    add_index :pending_games_notifications, [:game_id, :league_id, :user_id], unique: true, name: 'index_games_not_unique'
  end
end
