class CreatePendingGamesNotifications < ActiveRecord::Migration
  def change
    create_table :pending_games_notifications do |t|
      t.datetime :added_at
      t.boolean :read
      t.references :user, index: true
      t.references :league
      t.references :game
    end
  end
end
