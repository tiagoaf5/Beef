class AddIndexesToNotifications < ActiveRecord::Migration
  def change
    add_index :bet_score_notifications, [:bet_id, :user_id], unique: true, name: 'index_bet_notif_unique'
    add_index :invites_notifications, [:league_id, :user_id], unique: true, name: 'index_invites_notif_unique'
  end
end
