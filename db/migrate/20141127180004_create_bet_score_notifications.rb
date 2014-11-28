class CreateBetScoreNotifications < ActiveRecord::Migration
  def change
    create_table :bet_score_notifications do |t|
      t.datetime :added_at
      t.boolean :read
      t.references :user, index: true
      t.references :bet
    end
  end
end
