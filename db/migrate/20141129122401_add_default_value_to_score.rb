class AddDefaultValueToScore < ActiveRecord::Migration
  def change
    change_column :bets, :score, :integer, :default => 0
    change_column :league_users, :user_score, :integer, :default => 0
  end
end
